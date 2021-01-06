//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 19/11/2020.
//

import Foundation

enum TaskHandlerUrlCases {
    case getTasks(params: TaskHandlerParams)
    case getEmployeeDetail
    case activeCurrentTask(id: Int)
    case sendReportInfo(formData: [MultipartFormDataType])
}

class TaskHandlerUrlBuilder: BaseRequestBuilder<TaskHandlerUrlCases> {
    
    required init(urlCase: TaskHandlerUrlCases) {
        super.init(urlCase: urlCase)
    }
    
    override func build() -> URLRequest {
        switch urlCase {
        case .getTasks(let params):
            return .defaultRequest(path: "/task/listing", method: .get, parameters: params.build())
            
        case .getEmployeeDetail:
            return .defaultRequest(path: "/employee/detail", method: .get)
            
        case .activeCurrentTask(let id):
            
            return .defaultRequest(path: "/employee/active/\(id)",
                                    method: .post)
        case .sendReportInfo(let data):
            return .formDataRequest(path: "/report/create", method: .post, forms: data)
//            return .defaultRequest(path: "/report/create", method: .post)
        }
    }
}
