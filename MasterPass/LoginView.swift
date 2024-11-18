// LoginView.swift
// Manages user login and account creation with proper state handling.

import SwiftUI
import CryptoKit

struct LoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("loggedInUsername") private var loggedInUsername: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isCreatingAccount = false
    @State private var errorMessage: String = ""

    var body: some View {
        ZStack {
            // Red background
            Color.red.ignoresSafeArea()

            VStack(spacing: 20) {
                // Colorful Text Logo
                Text("MasterPass")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .yellow, .blue, .green],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .padding(.top, 50)

                // Username Field
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Password Field
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Error Message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }

                // Login or Create Account Button
                Button(action: isCreatingAccount ? createAccount : login) {
                    Text(isCreatingAccount ? "Create Account" : "Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                // Toggle Between Login and Create Account
                Button(action: {
                    isCreatingAccount.toggle()
                    errorMessage = ""
                }) {
                    Text(isCreatingAccount ? "Already have an account? Log In" : "Don't have an account? Create One")
                        .foregroundColor(.blue)
                }

                Spacer()
            }
        }
    }

    // MARK: - Authentication Functions

    private func login() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password cannot be empty."
            return
        }

        if let storedHashedPassword = UserDefaults.standard.string(forKey: username) {
            let hashedPassword = hashPassword(password)
            if hashedPassword == storedHashedPassword {
                loggedInUsername = username
                isLoggedIn = true
                errorMessage = ""
            } else {
                errorMessage = "Incorrect password."
            }
        } else {
            errorMessage = "Account does not exist."
        }
    }

    private func createAccount() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password cannot be empty."
            return
        }

        if UserDefaults.standard.string(forKey: username) != nil {
            errorMessage = "Account already exists."
        } else {
            let hashedPassword = hashPassword(password)
            UserDefaults.standard.set(hashedPassword, forKey: username)
            loggedInUsername = username
            isLoggedIn = true
            errorMessage = ""
        }
    }

    private func hashPassword(_ password: String) -> String {
        let hashed = SHA256.hash(data: Data(password.utf8))
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
