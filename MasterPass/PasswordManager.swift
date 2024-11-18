// Manages the saving, loading, and persistence of password entries.
// Handles secure storage of user passwords tied to their accounts.

import Foundation

class PasswordManager {
    static func savePasswords(_ passwords: [PasswordEntry], for username: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(passwords) {
            UserDefaults.standard.set(encoded, forKey: "Passwords_\(username)")
        }
    }

    static func loadPasswords(for username: String, completion: ([PasswordEntry]) -> Void) {
        if let data = UserDefaults.standard.data(forKey: "Passwords_\(username)") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([PasswordEntry].self, from: data) {
                completion(decoded)
                return
            }
        }
        completion([])
    }

    static func deleteAllPasswords(for username: String) {
        UserDefaults.standard.removeObject(forKey: "Passwords_\(username)")
    }
}
