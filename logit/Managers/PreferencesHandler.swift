//
//  PreferencesHandler.swift
//  logit
//
//  Created by Filippo Zaffoni on 06/06/24.
//

import Foundation
import SimpleKeychain

//enum PrefKeys {
//    static let selectedFolder = "selectedFolder"
//    static let username = "authorUsername"
//}

final class AppPreferences {
    
    // MARK: - Keys
    enum StorageKey: String {
        case selectedFolder
        case username
        case repoUrl
    }
    
    // MARK: - Properties
    @OptionalStorage<Data>(key: .selectedFolder)
    static var selectedFolder: Data?
    
    @OptionalStorage<String>(key: .username)
    static var username: String?
    
    @OptionalStorage<String>(key: .repoUrl)
    static var repoUrl: String?
    
    // MARK: - Methods
    static func removeData(for keys: Set<StorageKey>) {
        if keys.contains(.selectedFolder) { selectedFolder = nil }
        if keys.contains(.username) { username = nil }
        if keys.contains(.repoUrl) { repoUrl = nil }
    }
}

final class AppSecureKeys {
    
    // MARK: - Keys
    enum SecureKey: String {
        case openAIAPIKey
    }
    
    /// Twitch app token
    @SecureStorage(key: .openAIAPIKey)
    static var openAIAPIKey: String?
}

// MARK: - Storage property wrappers
@propertyWrapper
struct Storage<Value: PlistCompatible> {
    
    let key: AppPreferences.StorageKey
    let defaultValue: Value
    let storage: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            storage.object(forKey: key.rawValue) as? Value ?? defaultValue
        }
        set {
            storage.setValue(newValue, forKey: key.rawValue)
            storage.synchronize()
        }
    }
}

@propertyWrapper
struct OptionalStorage<Value: PlistCompatible> {
    
    let key: AppPreferences.StorageKey
    let storage: UserDefaults = .standard
    
    var wrappedValue: Value? {
        get {
            storage.object(forKey: key.rawValue) as? Value
        }
        set {
            storage.set(newValue, forKey: key.rawValue)
            storage.synchronize()
        }
    }
}

@propertyWrapper
struct SecureStorage {
    
    let key: AppSecureKeys.SecureKey
    let storage: SimpleKeychain = SimpleKeychain()
    
    var wrappedValue: String? {
        get {
            do {
                return try storage.string(forKey: key.rawValue)
            } catch {
                return nil
            }
        }
        set {
            if let value = newValue {
                do {
                    try storage.set(value, forKey: key.rawValue)
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                do {
                    try storage.deleteItem(forKey: key.rawValue)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
