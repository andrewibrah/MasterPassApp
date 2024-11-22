// Provides secure storage for sensitive data like passcodes using Keychain Services.
// Ensures data is encrypted and safely stored on the device.

import Foundation
import Security

class KeyChainManager {
    static func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        SecItemDelete(query) // Remove existing item if it exists
        return SecItemAdd(query, nil)
    }

    static func load(key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        return status == errSecSuccess ? result as? Data : nil
    }

    static func delete(key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        SecItemDelete(query)
    }
}
