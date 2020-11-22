//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

public struct MetadataModel: Codable {
    public init(total: Int? = nil, limit: Int? = nil, page: Int? = nil) {
        self.total = total
        self.limit = limit
        self.page = page
    }
    
    public var total: Int?
    public var limit: Int?
    public var page: Int?
}
