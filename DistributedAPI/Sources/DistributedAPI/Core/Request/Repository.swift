//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 19/11/2020.
//

import Foundation

public class Repository {
    
    public var authorizationData = AuthorizationData()
 
    public static let shared = Repository()
    
    private init() {}
    
    lazy var httpClient: HTTPClient = {
        
        let config = URLSessionConfiguration.default
        
        // Increase number of simultaneous API requests
        config.httpMaximumConnectionsPerHost = 15
        
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 30
        
        let session = URLSession(configuration: config)
        
        return HTTPClient(session: session)
    }()
    
    lazy var taskHandlerApi = TaskHandlerApi(httpClient: httpClient)
    
    lazy var authApi = AuthApi(httpClient: httpClient)
}

extension Repository {
    
    func handleResponse<T: Codable>(_ result: Result<T, Error>, completion: (Result<T, DataError>) -> Void) {
        switch result {
        case .success(let response):
            completion(.success(response))
        case .failure(let error):
            if let data = (error as? CombineResponseErrorAndData)?.dataError {
                let dataError = (try? JSONDecoder.shared.decode(DataError.self, from: data)) ?? DataError(error: nil)
                completion(.failure(dataError))
            }
        }
    }
}
