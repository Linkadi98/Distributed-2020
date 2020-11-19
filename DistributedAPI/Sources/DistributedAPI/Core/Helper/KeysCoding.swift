//
//  File.swift
//
//
//  Created by Kien Nguyen on 10/14/20.
//

import Foundation

/// A type that willl use a custom key decoding strategy when being decoded
public protocol UseCustomKeyDecodingStrategyType {
    static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
}

/// A type that willl use a `.useDefaultKeys` key decoding strategy when being decoded
public protocol UseKeyDecodingStrategyDefaults: UseCustomKeyDecodingStrategyType {
    
}

public extension UseKeyDecodingStrategyDefaults {
    static var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        .useDefaultKeys
    }
}

/// A type that willl use a custom key encoding strategy when being encoded
public protocol UseCustomKeyEncodingStrategyType {
    var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { get }
}

/// A type that willl use `.useDefaultKeys` key encoding strategy when being encoded
public protocol UseKeyEncodingStrategyDefaults: UseCustomKeyEncodingStrategyType {
    
}

public extension UseKeyEncodingStrategyDefaults {
    var keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy {
        .useDefaultKeys
    }
}

/// A type that uses `.useDefaultKeys` for both decoding and encoding object
public protocol UseKeyCodingStrategyDefaults: UseKeyDecodingStrategyDefaults, UseKeyEncodingStrategyDefaults {}
