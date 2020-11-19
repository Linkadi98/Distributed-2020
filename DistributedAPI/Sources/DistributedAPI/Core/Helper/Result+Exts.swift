//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

extension Result {
    func get(defaultValue: Success) -> Success {
        switch self {
        case .success(let success):
            return success
        case .failure:
            return defaultValue
        }
    }
}
