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
    
    @discardableResult
    func getEmployeeDetail(completion: @escaping (Result<EmployeeDetailResponse, DataError>) -> Void) -> CancellableRequest {
        return taskHandlerApi.getEmployeeDetail(completion: {
            self.handleResponse($0) { (r) in
                switch r {
                case .success(let res):
                    completion(.success(res))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        })
    }
    
    @discardableResult
    func activeCurrentTask(id: Int, completion: @escaping (Result<EmptyResponse, DataError>) -> Void) -> CancellableRequest {
        
        return taskHandlerApi.activeCurrentTask(id: id) { (r) in
            self.handleResponse(r, completion: {
                switch $0 {
                case .success(let res):
                    completion(.success(res))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }
    
    @discardableResult
    func sendReportInfo(data: ReportData, comletion: @escaping ((Result<EmptyResponse, DataError>) -> Void)) -> CancellableRequest {
       
        return taskHandlerApi.sendReportInfo(data: data, comletion: {
            self.handleResponse($0) { (r) in
                switch r {
                case .success:
                    comletion(.success(EmptyResponse()))
                case .failure(let error):
                    comletion(.failure(error))
                }
            }
        })
    }
}
