//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 19/11/2020.
//

import Foundation

public extension Repository {
    
    @discardableResult
    func getAllTasks(params: TaskHandlerParams,
                     completion: @escaping (Result<TasksResponse, Error>) -> Void) -> CancellableRequest {
        
        return taskHandlerApi.getAllTasks(params: params,
                                          completion: completion)
        
    }
}
