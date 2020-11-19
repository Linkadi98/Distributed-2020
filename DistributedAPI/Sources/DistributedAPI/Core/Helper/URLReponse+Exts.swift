//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

extension HTTPURLResponse {
    
    var status: HTTPStatusCode? {
        return HTTPStatusCode(rawValue: statusCode)
    }
    var responseError: HttpResponseError? {
        return HttpResponseError(rawValue: statusCode)
    }
    
}

extension URLResponse {
    var statusCode: HTTPStatusCode? {
        return (self as? HTTPURLResponse)?.status
    }
    
    var error: HttpResponseError? {
        return (self as? HTTPURLResponse)?.responseError
    }
    
}
