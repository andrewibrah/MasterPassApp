// Provides feedback on the strength of a password.
// Evaluates password length, variety of characters, and overall security.

import Foundation

class PasswordStrengthMeter {
    enum Strength: String {
        case veryWeak = "Very Weak"
        case weak = "Weak"
        case moderate = "Moderate"
        case strong = "Strong"
        case veryStrong = "Very Strong"
    }

    static func evaluate(password: String) -> Strength {
        let lengthScore = password.count >= 8 ? 1 : 0
        let containsUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil ? 1 : 0
        let containsLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil ? 1 : 0
        let containsNumber = password.range(of: "\\d", options: .regularExpression) != nil ? 1 : 0
        let containsSpecialChar = password.range(of: "[^a-zA-Z0-9]", options: .regularExpression) != nil ? 1 : 0

        let score = lengthScore + containsUppercase + containsLowercase + containsNumber + containsSpecialChar

        switch score {
        case 0...1:
            return .veryWeak
        case 2:
            return .weak
        case 3:
            return .moderate
        case 4:
            return .strong
        default:
            return .veryStrong
        }
    }
}
