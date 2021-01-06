//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 21/11/2020.
//

import Foundation

public enum AuthUrlCases {
    case login
}

class AuthUrlRequestBuilder: BaseRequestBuilder<AuthUrlCases> {
    required init(urlCase: AuthUrlCases) {
        super.init(urlCase: urlCase)
    }
    
    override func build() -> URLRequest {
        switch urlCase {
        case .login:
            return .defaultRequest(endpoint: .dsd08, path: "/employee/login", method: .post)
        }
    }
}
