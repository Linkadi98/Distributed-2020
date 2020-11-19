//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

extension URLRequest {
    var method: HTTPMethod? {
        get {
            guard let method = self.httpMethod else { return nil }
            
            return HTTPMethod(rawValue: method)
        }
        set {
            httpMethod = newValue?.rawValue
        }
    }
}

public protocol EndpointMakable {
    var components: (host: String, basePath: String) { get }
    var port: Int? { get }
}

public enum EndpointPool: EndpointMakable {
    case dsd08
    
    public var port: Int? {
        switch self {
        case .dsd08:
            return nil
        }
    }
    
    public var scheme: String {
        switch self {
        case .dsd08:
            return "https"
        }
    }
    
    public var components: (host: String, basePath: String) {
        switch self {
        case .dsd08:
            return ("distributed-dsd08.herokuapp.com", "/api")
        }
    }
}

class URLRequestBuilder {
    private let endpoint: EndpointPool
    
    private var urlRequest: URLRequest!
    
    init(endpoint: EndpointPool) {
        self.endpoint = endpoint
    }
    
    func build() -> URLRequest {
        guard let urlRequest = urlRequest else {
            fatalError("urlRequest is nil 😭")
        }
        
        return urlRequest
    }
    
    func configUrl(path: String,
                   method: HTTPMethod,
                   body: Data? = nil,
                   headers: [String: String]? = nil,
                   parameters: Parameters? = nil,
                   cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy) -> URLRequestBuilder {
        let url = generateUrlComponent(path: path, parameters: parameters)
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = buildAuthorizationHeader(from: headers)
        urlRequest.cachePolicy = cachePolicy
        urlRequest.httpBody = body
        
        self.urlRequest = urlRequest
        return self
    }
    
    private func generateUrlComponent(path: String, parameters: Parameters?) -> URL {
        var components = URLComponents()
        
        let (host, basePath) = endpoint.components
        components.scheme = endpoint.scheme
        components.host = host
        components.port = endpoint.port
        components.path = basePath + path
        
        components.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: "\($0.value)")}
        
        components.percentEncodedQuery = components.percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")
        
        return components.url!
    }
    
    private func buildAuthorizationHeader(from header: [String: String]?) -> [String: String]? {
        var defaultHeader: [String: String] = [:]
        defaultHeader[ApiContants.contentType] = ApiContants.applicationJson
        
        
        return defaultHeader.joined(header ?? [:])
    }
}

extension URLRequest {
    static func defaultRequest(token: String? = nil,
                               path: String,
                               method: HTTPMethod,
                               body: Data? = nil,
                               headers: [String: String]? = nil,
                               parameters: Parameters? = nil) -> URLRequest {
        var header = [String: String]()
        if let token = token {
            /// for token
        }
        
        return URLRequestBuilder(endpoint: .dsd08).configUrl(path: path,
                                                             method: method,
                                                             body: body,
                                                             headers: header,
                                                             parameters: parameters).build()
    }
}

extension Dictionary {
    mutating func join(_ other: [Key: Value?]) {
        other.compactMapValues({ $0 }).forEach({ self[$0.key] = $0.value })
    }
    
    func joined(_ other: [Key: Value?]) -> [Key: Value] {
        var dict = self
        dict.join(other)
        return dict
    }
    
    func toJson(beautify: Bool = false) -> String? {
        guard let data = try? JSONSerialization.data(
                withJSONObject: self,
                options: beautify ? .prettyPrinted : .init()) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}

extension Encodable {
    func toData(using encoder: JSONEncoder = .shared) -> Data? {
        try? encoder.encode(self)
    }
}
