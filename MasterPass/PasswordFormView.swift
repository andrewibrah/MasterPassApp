// Provides the interface for creating and saving new password entries.
// Includes fields for service details, username, and secure password storage with a random password generator and strength meter.

import SwiftUI

struct PasswordFormView: View {
    @Binding var savedPasswords: [PasswordEntry]
    @Environment(\.presentationMode) var presentationMode
    @State private var serviceName: String = ""
    @State private var website: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var passwordStrength: String = "Weak"
    @State private var passwordStrengthColor: Color = .red

    @AppStorage("loggedInUsername") private var loggedInUsername: String = ""

    var body: some View {
        Form {
            Section(header: Text("New Password")) {
                TextField("Service Name", text: $serviceName)
                TextField("Website", text: $website)
                TextField("Username (optional)", text: $username)
                TextField("Email (optional)", text: $email)
                SecureField("Password", text: $password)
                    .onChange(of: password) { newPassword in
                        evaluatePasswordStrength(newPassword)
                    }
                
                // Password Strength Meter
                HStack {
                    Text("Strength:")
                    Text(passwordStrength)
                        .foregroundColor(passwordStrengthColor)
                        .bold()
                }

                // Random Password Generator Button
                Button(action: generateRandomPassword) {
                    Text("Generate Random Password")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }

            Button(action: addPassword) {
                Text("Save Password")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Success"),
                message: Text("Password Added!"),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss() // Close the view
                }
            )
        }
    }

    private func addPassword() {
        guard !serviceName.isEmpty, !password.isEmpty else {
            return // Ensure required fields are not empty
        }

        let newPasswordEntry = PasswordEntry(
            serviceName: serviceName,
            website: website.isEmpty ? "N/A" : website,
            username: username.isEmpty ? "N/A" : username,
            email: email.isEmpty ? "N/A" : email,
            password: password
        )

        // Append the password and save to UserDefaults
        savedPasswords.append(newPasswordEntry)
        PasswordManager.savePasswords(savedPasswords, for: loggedInUsername)

        showAlert = true // Show success alert
    }

    private func generateRandomPassword() {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
        password = String((0..<12).map { _ in characters.randomElement()! })
    }

    private func evaluatePasswordStrength(_ password: String) {
        let lengthScore = password.count >= 12 ? 1 : 0
        let upperCaseScore = password.rangeOfCharacter(from: .uppercaseLetters) != nil ? 1 : 0
        let lowerCaseScore = password.rangeOfCharacter(from: .lowercaseLetters) != nil ? 1 : 0
        let digitScore = password.rangeOfCharacter(from: .decimalDigits) != nil ? 1 : 0
        let specialCharScore = password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()")) != nil ? 1 : 0

        let totalScore = lengthScore + upperCaseScore + lowerCaseScore + digitScore + specialCharScore

        switch totalScore {
        case 5:
            passwordStrength = "Very Strong"
            passwordStrengthColor = .green
        case 4:
            passwordStrength = "Strong"
            passwordStrengthColor = .blue
        case 3:
            passwordStrength = "Medium"
            passwordStrengthColor = .yellow
        case 2:
            passwordStrength = "Weak"
            passwordStrengthColor = .orange
        default:
            passwordStrength = "Very Weak"
            passwordStrengthColor = .red
        }
    }
}
