//
//  AccountManager.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 21/11/2020.
//

import Foundation
import DistributedAPI

struct SavedAccount {
    let account: Account
    
    var token: String? {
        account.apiToken
    }
    
    var name: String? {
        account.fullName
    }
}

class AccountManager {
    
    static let shared = AccountManager()
    
    private var userDefault: UserDefaults = .standard
    
    private final let currentAccountKey = "currentAccountKey"
    
    private init() {
        getLoggedInAccount()
    }
    
    var currentAccount: SavedAccount? {
        didSet {
            let authorizationData = AuthorizationData(apiToken: currentAccount?.token)
            Repository.shared.authorizationData = authorizationData
        }
    }
    
    var isLoggedIn: Bool {
        return currentAccount != nil
    }
    
    func save(_ account: Account?) {
        guard let account = account else { return }
        
        userDefault.save(withKey: currentAccountKey, value: account)
    }
    
    func getLoggedInAccount() {
        if let lastLoginAccount = userDefault.load(withKey: currentAccountKey, type: Account.self) {
            currentAccount = SavedAccount(account: lastLoginAccount)
            print(currentAccount)
        }
    }
}
