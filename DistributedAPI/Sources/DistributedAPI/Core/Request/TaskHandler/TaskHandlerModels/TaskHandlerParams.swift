//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 19/11/2020.
//

import Foundation

public struct TaskHandlerParams: Params {
    public let id: Int?
    
    func customParams() -> Parameters {
        var params: Parameters = [:]
        
        params["id"] = id
        
        return params
    }
}
