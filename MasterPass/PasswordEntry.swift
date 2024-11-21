import Foundation

struct PasswordEntry: Identifiable, Codable {
    let id: UUID
    let serviceName: String
    let website: String
    let username: String
    let email: String
    var password: String
    var passwordHidden: Bool

    init(
        id: UUID = UUID(),
        serviceName: String,
        website: String,
        username: String,
        email: String,
        password: String,
        passwordHidden: Bool = true
    ) {
        self.id = id
        self.serviceName = serviceName
        self.website = website
        self.username = username
        self.email = email
        self.password = password
        self.passwordHidden = passwordHidden
    }
}
