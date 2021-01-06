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
    
    func getEmployeeDetail(completion: @escaping (Result<EmployeeDetailResponse, Error>) -> Void) -> CancellableRequest {
        return client.makeRequest(request: TaskHandlerUrlBuilder(urlCase: .getEmployeeDetail).build(), completion: completion)
    }
    
    func activeCurrentTask(id: Int, completion: @escaping (Result<EmptyResponse, Error>) -> Void) -> CancellableRequest {
        return client.makeRequest(request: TaskHandlerUrlBuilder(urlCase: .activeCurrentTask(id: id)).build(),
                                  completion: completion)
    }
    
    func sendReportInfo(data: ReportData, comletion: @escaping ((Result<EmptyResponse, Error>) -> Void)) -> CancellableRequest {
        let formDataBuilder = MultipartFormDataBuilder()
        
        let formData = data.toMultipartFormData()
        
        return client.makeRequest(request: TaskHandlerUrlBuilder(urlCase: .sendReportInfo(formData: formData)).build(),
                                  completion: comletion)
    }
}
