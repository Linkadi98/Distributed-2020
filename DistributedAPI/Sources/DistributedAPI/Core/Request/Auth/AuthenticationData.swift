//
//  File.swift
//  
//
//  Created by Minh Pham Ngoc on 21/11/2020.
//

import Foundation

public struct LoginRequest: Encodable {
    public init(user: String?, password: String?) {
        self.username = user
        self.password = password
    }
    
    public let username: String?
    public let password: String?
}

public struct AccountResponse: Codable {
    public let result: Account?
}

public struct Account: Codable {
    public init(id: Int? = nil, fullName: String? = nil, username: String? = nil, phone: Int? = nil, email: String? = nil, address: String? = nil, birthday: String? = nil, avatar: String? = nil, type: String? = nil, status: String? = nil, role: String? = nil, apiToken: String? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.fullName = fullName
        self.username = username
        self.phone = phone
        self.email = email
        self.address = address
        self.birthday = birthday
        self.avatar = avatar
        self.type = type
        self.status = status
        self.role = role
        self.apiToken = apiToken
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    public var id: Int?
    public var fullName: String?
    public var username: String?
    public var phone: Int?
    public var email: String?
    public var address: String?
    public var birthday: String?
    public var avatar: String?
    public var type: String?
    public var status: String?
    public var role: String?
    public var apiToken: String?
    public var createdAt: Date?
    public var updatedAt: Date?
}

public struct AuthorizationData {
    public init(apiToken: String?) {
        self.apiToken = apiToken
    }
    
    public var apiToken: String?
}
