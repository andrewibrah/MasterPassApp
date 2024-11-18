// PasswordEntry.swift
// Represents a password entry with details like service name, website, username, and password.
import Foundation

struct PasswordEntry: Identifiable, Codable {
    let id: UUID
    let serviceName: String
    let website: String
    let username: String
    let email: String
    var password: String
    var passwordHidden: Bool = true

    init(serviceName: String, website: String, username: String, email: String, password: String) {
        self.id = UUID()
        self.serviceName = serviceName
        self.website = website
        self.username = username
        self.email = email
        self.password = password
    }
}
