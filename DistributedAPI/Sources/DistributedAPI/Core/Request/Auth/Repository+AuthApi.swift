//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 21/11/2020.
//

import Foundation

public extension Repository {
    func login(sendingData: LoginRequest, completion: @escaping (Result<AccountResponse, Error>) -> Void) -> CancellableRequest {
        return authApi.login(sendingData: sendingData, completion: completion)
    }
}
