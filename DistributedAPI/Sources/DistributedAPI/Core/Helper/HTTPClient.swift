//
//  HTTPClient.swift
//  SapoAdminIOS
//
//  Created by ThangTM-PC on 11/7/19.
//  Copyright © 2019 ThangTM-PC. All rights reserved.
//

import Foundation

private let TAG = "[HTTPClient]"
private let responseTimeWarningThreshold: Double = 1500 // ms

class HTTPClient {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    /// Overload to default infer `T` as `EmptySendingData?` when want to pass nil as `body` parameter
    @discardableResult
    func makeRequest<R>(request: URLRequest,
                     completion: @escaping (Result<R, Error>) -> Void) -> CancellableRequest where R: Decodable {
        makeRequest(request: request, sendingData: nil as EmptySendingData?, completion: completion)
    }
    
    @discardableResult
    func makeRequest<T, R>(request: URLRequest,
                        sendingData: T?,
                        completion: @escaping (Result<R, Error>) -> Void) -> CancellableRequest where T: Encodable, R: Decodable {
        var request = request
        
        let requestUrl = request.url?.absoluteString ?? ""
        
        print("Method:", request.httpMethod ?? "UNKNOWN", "-", requestUrl)
        print("Headers:", request.allHTTPHeaderFields ?? [:])
        
        if request.httpBody == nil {
            if let type = sendingData as? UseCustomKeyEncodingStrategyType {
                let encoder = JSONEncoder.createDefaults()
                encoder.keyEncodingStrategy = type.keyEncodingStrategy
                request.httpBody = sendingData?.toData(using: encoder)
            } else {
                request.httpBody = sendingData?.toData()
            }
        }
        
        if let body = request.httpBody {
            print("Body:", String(data: body, encoding: .utf8) ?? "")
        }
        
        let startTime: DispatchTime? = .now()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                self.handleDataTask(request: request,
                                    method: HTTPMethod(rawValue: request.httpMethod ?? ""),
                                    data: data,
                                    response: response,
                                    error: error,
                                    completion: completion,
                                    startTime: startTime)
            }
        }
        
        task.resume()
        return task
    }
    
    private func handleDataTask<R>(request: URLRequest,
                                   method: HTTPMethod?,
                                   data: Data?,
                                   response: URLResponse?,
                                   error: Error?,
                                   completion: @escaping (Result<R, Error>) -> Void,
                                   startTime: DispatchTime? = nil) where R: Decodable {
        
        let requestUrl = request.url?.absoluteString ?? ""
        
        if let start = startTime {
            let duration = Double(DispatchTime.now().uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000
            print("Response time:", duration > responseTimeWarningThreshold ? "⚠️" : "",
                          "\(round(duration)) ms", "-", requestUrl)
        }
        
        if let error = error {
            if let nsError = error as NSError?, nsError.code == URLError.Code.cancelled.rawValue {
                print("Cancelled: ", requestUrl)
                return
            }
            
            completion(.failure(error))
            return
        }
        
        guard let statusCode = (response as? HTTPURLResponse)?.status else {
            completion(.failure(HttpResponseError.noStatusCode))
            print(TAG, requestUrl, String(describing: response))
            return
        }
        
        guard let receivedData = data else {
            completion(.failure(HttpResponseError.noReturnData))
            print(TAG, requestUrl, "- noReturnData")
            return
        }
        
        print("Response body:", String(data: receivedData, encoding: .utf8) ?? "")
        
        if method != .get, let responseBody = String(data: receivedData, encoding: .utf8) {
            print(TAG, "Response body:", responseBody)
        }
        
        switch statusCode.responseType {
        case .informational: break
        case .success,
             .redirection:
            
            if let empty = EmptyResponse() as? R {
                completion(.success(empty))
                return
            }
            
            do {
                let decoder: JSONDecoder
                
                if let type = R.self as? UseCustomKeyDecodingStrategyType.Type {
                    decoder = JSONDecoder.createDefaults()
                    decoder.keyDecodingStrategy = type.keyDecodingStrategy
                } else {
                    decoder = .shared
                }
                
                let parsedObject = try decoder.decode(R.self, from: receivedData)
                completion(.success(parsedObject))
            } catch let error {
                completion(.failure(HttpResponseError.decodeReceivedDataFail))
                print(requestUrl, "- decodeReceivedDataFail: ", error)
            }
            
        default:
            let error = response?.error ?? HttpResponseError.undefine
            let errorResponse = CombineResponseErrorAndData(dataError: receivedData, responseError: error)
            completion(.failure(errorResponse))
            self.logError(error: error,
                          data: receivedData,
                          request: request)
        }
    }
    
    private func logError(error: Error, data: Data?, request: URLRequest) {
        
        let requestUrl = request.url?.absoluteString ?? ""
        
        guard let errorData = data, errorData.count > 0 else {
            print(TAG, requestUrl, "-", error)
            return
        }
        
        guard let errorObject = try? JSONSerialization.jsonObject(with: errorData, options: .init()) else {
            if let errorString = String(data: errorData, encoding: .utf8) {
                print(TAG, requestUrl, "-", errorString)
            } else {
                print(TAG, requestUrl, "-", error.localizedDescription)
            }
            return
        }
        
        if let errorDict = errorObject as? [String: Any] {
            print(TAG, requestUrl, errorDict.toJson(beautify: true) ?? "")
        } else {
            print(TAG, requestUrl, "-", errorObject)
        }
    }
}
