//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

public extension JSONDecoder {
    static var shared: JSONDecoder = {
        let decoder = JSONDecoder.createDefaults()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}

public extension JSONEncoder {
    static var shared: JSONEncoder = {
        let encoder = JSONEncoder.createDefaults()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
}

extension JSONDecoder {
    static func createDefaults() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customDSD08
        return decoder
    }
}

extension JSONEncoder {
    static func createDefaults() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .customDSD08
        return encoder
    }
}
