//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 21/11/2020.
//

import Foundation

public class AuthApi {
    
    let client: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.client = httpClient
    }
    
    func login(sendingData: LoginRequest, completion: @escaping (Result<AccountResponse, Error>) -> Void) -> CancellableRequest {
        return client.makeRequest(request: AuthUrlRequestBuilder(urlCase: .login).build(), sendingData: sendingData, completion: completion)
    }
}
