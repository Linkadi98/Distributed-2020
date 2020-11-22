//
//  UserDefault+Exts.swift
//  Distributed2020
//
//  Created by Minh Pham Ngoc on 21/11/2020.
//

import Foundation

extension UserDefaults {
    public func load<T: Codable>(withKey key: String, type: T.Type) -> T? {
        let userDefault = UserDefaults.standard
        switch type {
        case is String.Type:
            return userDefault.string(forKey: key) as? T
        case is Int.Type:
            return userDefault.integer(forKey: key) as? T
        case is Double.Type:
            return userDefault.double(forKey: key) as? T
        case is Float.Type:
            return userDefault.float(forKey: key) as? T
        case is Data.Type:
            return userDefault.data(forKey: key) as? T
        case is URL.Type:
            return  userDefault.url(forKey: key) as? T
        case is [String].Type:
            return userDefault.stringArray(forKey: key) as? T
        case is Bool.Type:
            return userDefault.bool(forKey: key) as? T
            
        default:
            if let data = userDefault.object(forKey: key) as? Data {
                return try? JSONDecoder.shared.decode(T.self, from: data)
            } else {
                return nil
            }
        }
        
    }
    
    @discardableResult
    public func save<T: Codable>(withKey key: String, value: T?) -> Bool {
        guard let value = value else {
            return false
        }
        
        switch value {
        case let v as String:
            set(v, forKey: key)
        case let v as Int:
            set(v, forKey: key)
        case let v as Double:
            set(v, forKey: key)
        case let v as Float:
            set(v, forKey: key)
        case let v as Data:
            set(v, forKey: key)
        case let v as URL:
            set(v, forKey: key)
        case let v as [String]:
            set(v, forKey: key)
        case let v as Bool:
            set(v, forKey: key)
        default:
            let encodeData = try? JSONEncoder.shared.encode(value)
            set(encodeData, forKey: key)
        }
        
        return true
        
    }
}
