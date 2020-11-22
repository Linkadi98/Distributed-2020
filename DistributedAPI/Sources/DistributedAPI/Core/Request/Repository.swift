//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 19/11/2020.
//

import Foundation

public class Repository {
    
    public var authorizationData = AuthorizationData(apiToken: "")
 
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
