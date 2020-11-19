//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 18/11/2020.
//

import Foundation

public protocol CancellableRequest {
    func cancel()
}

// A request that do nothing
public class EmptyRequest: CancellableRequest {
    public func cancel() {
        // do nothing
    }
}

extension URLSessionTask: CancellableRequest {}

