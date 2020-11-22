//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 19/11/2020.
//

import Foundation

public struct TasksResponse: Codable {
    public var metadata: MetadataModel?
    public var tasks: [Task]?
}

public struct Task: Codable {
    public var id: Int?
    public var name: String?
    public var type: String?
    public var captainId: Int?
    public var status: String?
    public var level: String?
    public var incidentId: Int?
    public var priority: String?
    public var createdAt: Date?
    public var updatedAt: Date?
}
