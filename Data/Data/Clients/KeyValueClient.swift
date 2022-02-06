//
//  KeyValueClienr.swift
//  Data
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import Foundation
import KeychainAccess
import CommonExtensions

public protocol KeyValueClient {
    func save(key: String, value: String)
    func save(key: String, value: Data)
    func get(key: String) -> String?
    func getData(for key: String) -> Data?
    func delete(key: String)
    func removeAll()
}

private let isLoggedIn = "isLoggedIn"


public extension KeyValueClient {
    func saveLoginState() {
        save(key: isLoggedIn, value: true)
    }
    
    func getLoginState() -> Bool? {
        getBool(key: isLoggedIn)
    }
    
}

public extension KeyValueClient {
    
    func save(key: String, value: Bool) {
        save(
            key: key,
            value: value ? "yes" : "no"
        )
    }
    
    func getBool(key: String) -> Bool? {
        get(key: key).map { $0 == "yes" || $0 == "" }
    }
    
    func removeUserCreds(isLogout: Bool) {
        delete(key: isLoggedIn)
    }
}

public class KeychainService: KeyValueClient {
    
    let lockCredentials = Keychain()
    
    public init() { }
    
    public func save(key: String, value: String) {
        do {
            try lockCredentials.set(value, key: key)
        } catch let error {
            print("KEYCHAIN SAVE :: Failed to save this value with this key \(key) => \(error)")
        }
    }
    
    public func save(key: String, value: Data) {
        do {
            try lockCredentials.set(value, key: key)
        } catch {
            print("KEYCHAIN SAVE OBJ :: Failed to save this object with this key \(key)")
        }
    }
    
    public func get(key: String) -> String? {
        return lockCredentials[string: key]
    }
    
    public func getData(for key: String) -> Data? {
        do {
            guard let key = try lockCredentials.getData(key) else { return nil }
            return key
        } catch {
            print(error)
            return nil
        }
    }
    
    public func delete(key: String) {
        do {
            try lockCredentials.remove(key)
        } catch {
            print("KEYCHAIN DELETE :: Failed to remove keychain data with this key : \(key)")
        }
    }
    
    // MARK: Remove All
    public func removeAll() {
        let creds =  lockCredentials.allKeys()
        creds.filter { $0 != "biometricToken" && $0 != "biometricIdentity"}
            .forEach { delete(key: $0)}
    }
}

public class KeychainMock: KeyValueClient {
    
    var stores: [String: Any] = [:] {
        didSet {
            print("keychian mock values ",stores)
        }
    }
    
    public init(store: [String: Any] = [:]) {
        self.stores = store
    }
    
    public func save(key: String, value: String) {
        stores[key] = value
    }
    
    public func save(key: String, value: Data) {
        stores[key] = value
    }
    
    public func get(key: String) -> String? {
        return stores[key] as? String
    }
    
    public func getData(for key: String) -> Data? {
        return stores[key] as? Data
    }
    
    public func delete(key: String) {
        stores.removeValue(forKey: key)
    }
    
    public func removeAll() {
        stores.removeAll()
    }
    
}

