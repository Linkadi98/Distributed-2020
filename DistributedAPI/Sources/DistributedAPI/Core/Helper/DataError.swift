//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 13/12/2020.
//

import Foundation

public struct DataError: Decodable, Error {
    public let error: ErrorModel?
}

public struct ErrorModel: Decodable {
    public let message: String?
}

public extension DataError {
    var errorMessage: String {
        error?.message ?? "Có lỗi xảy ra!"
    }
}
