//
//  AccountManager.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 21/11/2020.
//

import Foundation
import DistributedAPI

struct SavedAccount {
    let employee: Employee?
    
    var token: String? {
        employee?.apiToken
    }
    
    var name: String? {
        employee?.fullName
    }
    
    var projectType: String? {
        employee?.type
    }
    
    var createdDate: String? {
        employee?.createdAt?.toString(format: .customDateTimeSecWithoutZone)
    }
    
    var role: String? {
        employee?.role?.lowercased()
    }
}

class AccountManager {
    
    static let shared = AccountManager()
    
    private var userDefault: UserDefaults = .standard
    
    private final let currentAccountKey = "currentAccountKey"
    
    private init() {
        getLastLoggedInEmployeeInfo()
    }
    
    var currentAccount: SavedAccount? {
        didSet {
            let authorizationData = AuthorizationData(apiToken: currentAccount?.token,
                                                      projectType: currentAccount?.projectType)
            Repository.shared.authorizationData = authorizationData
        }
    }
    
    var isLoggedIn: Bool {
        return currentAccount != nil
    }
    
    func save(_ employeeInfo: Employee?) {
        guard let employeeInfo = employeeInfo else { return }
        currentAccount = SavedAccount(employee: employeeInfo)
        
        userDefault.removeObject(forKey: currentAccountKey)
        userDefault.save(withKey: currentAccountKey, value: employeeInfo)
    }
    
    func getLastLoggedInEmployeeInfo() {
        if let lastLoginAccount = userDefault.load(withKey: currentAccountKey, type: Employee.self) {
            currentAccount = SavedAccount(employee: lastLoginAccount)
        }
    }
    
    func removeCurrentEmployee() {
        userDefault.removeObject(forKey: currentAccountKey)
    }
}
