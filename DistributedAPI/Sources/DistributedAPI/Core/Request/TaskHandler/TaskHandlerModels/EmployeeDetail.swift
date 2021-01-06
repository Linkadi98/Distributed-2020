//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 02/12/2020.
//

import Foundation

public struct EmployeeDetailResponse: Codable {
    public var employee: Employee?
    public var currentTask: Task?
    public var activeCurrentTask: Bool?
    public var isCaptain: Bool?
    public var pendingTasks: [Task]?
}

public struct Employee: Codable {
    public var id: Int?
    public var fullName: String?
    public var email: String?
//    public var avatar: 
    public var type: String?
    public var status: String?
    public var role: String?
//    public var status_activation: "FREE"
    public var apiToken: String?
    public var createdAt: Date?
    
    public var projectType: String {
        switch type {
        case "LUOI_DIEN":
            return "Lưới điện"
        default:
            return ""
        }
    }
}
