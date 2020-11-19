//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

typealias Parameters = [String: Any]

protocol Params {
    func customParams() -> Parameters
}

extension Params {
    func build() -> Parameters {
        return customParams()
    }
}
