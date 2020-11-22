//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

public enum PageSize {
    case small
    case medium
    case large
    case custom(Int)
    
    public var value: Int {
        switch self {
        case .small:
            return 10
        case .medium:
            return 20
        case .large:
            return 50
        case .custom(let customValue):
            return customValue
        }
    }
}
