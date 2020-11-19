//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

protocol URLRequestBuildable {
    func build() -> URLRequest
}

class BaseRequestBuilder<URLCases>: URLRequestBuildable {
    
    internal var urlCase: URLCases
    
    required init(urlCase: URLCases) {
        self.urlCase = urlCase
    }
    
    func build() -> URLRequest {
        fatalError("Must implement in subclasses")
    }
    
}
