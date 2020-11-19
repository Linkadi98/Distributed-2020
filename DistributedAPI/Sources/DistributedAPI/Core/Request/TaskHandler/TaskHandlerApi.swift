//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 19/11/2020.
//

import Foundation

class TaskHandlerApi {
    
    private let client: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.client = httpClient
    }
    
    func getAllTasks(params: TaskHandlerParams,
                     completion: @escaping (Result<TasksResponse, Error>) -> Void) -> CancellableRequest {
        
        return client.makeRequest(request: TaskHandlerUrlBuilder(urlCase: .getTasks(params: params)).build(),
                                  completion: completion)
        
    }
}
