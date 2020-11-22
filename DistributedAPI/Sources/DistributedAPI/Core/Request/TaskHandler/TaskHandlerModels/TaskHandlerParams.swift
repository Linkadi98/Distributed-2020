//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 19/11/2020.
//

import Foundation

public struct TaskHandlerParams: Params {
    public init() {}
    
    public var id: Int?
    public var page: Int?
    public var limit: Int?
    
    func customParams() -> Parameters {
        var params: Parameters = [:]
        
        params["id"] = id
        params["page"] = page
        params["limit"] = limit
        
        return params
    }
}
