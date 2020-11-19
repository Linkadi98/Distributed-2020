//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 19/11/2020.
//

import Foundation

enum TaskHandlerUrlCases {
    case getTasks(params: TaskHandlerParams)
}

class TaskHandlerUrlBuilder: BaseRequestBuilder<TaskHandlerUrlCases> {
    
    required init(urlCase: TaskHandlerUrlCases) {
        super.init(urlCase: urlCase)
    }
    
    override func build() -> URLRequest {
        switch urlCase {
        case .getTasks(let params):
            return .defaultRequest(path: "/task/listing", method: .get, parameters: params.build())
        }
    }
}
