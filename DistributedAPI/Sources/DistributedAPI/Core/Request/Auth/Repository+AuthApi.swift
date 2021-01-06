//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 21/11/2020.
//

import Foundation

public extension Repository {
    func login(sendingData: LoginRequest, completion: @escaping (Result<AccountResponse, DataError>) -> Void) -> CancellableRequest {
        return authApi.login(sendingData: sendingData, completion: {
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
}
