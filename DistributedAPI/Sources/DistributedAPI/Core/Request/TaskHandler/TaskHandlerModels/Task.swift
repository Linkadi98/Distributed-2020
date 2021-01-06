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

public enum TaskLevel: String {
    case none
    case urgency = "Urgency"
}

public enum TaskPriority: String {
    case none = ""
    case low = "1"
    case medium = "2"
    case high = "3"
    case highest = "4"
    case urgency = "5"
}

public struct Task: Codable {
    public var id: Int?
    public var status: String?
    public var taskType: TaskType?
        
    public var statusText: String? {
        switch status {
        case "doing":
            return "Đang xử lý"
        case "pending":
            return "Đang chờ xử lý"
        default:
            return "---"
        }
    }
}

public struct TaskType: Codable {
    public var id: Int?
    public var name: String?
    public var description: String?
    public var employeeNumber: Int?
}
