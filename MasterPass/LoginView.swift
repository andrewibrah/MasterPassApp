import SwiftUI
import CryptoKit

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isCreatingAccount = false
    @State private var errorMessage: String = ""
    
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text(isCreatingAccount ? "Create Account" : "Sign In")
                .font(.largeTitle)
                .bold()
                .padding(.top, 50)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                if isCreatingAccount {
                    createAccount()
                } else {
                    signIn()
                }
            }) {
                Text(isCreatingAccount ? "Create Account" : "Sign In")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            Button(action: {
                isCreatingAccount.toggle()
            }) {
                Text(isCreatingAccount ? "Already have an account? Sign In" : "Don't have an account? Create One")
                    .foregroundColor(.blue)
                    .padding(.top)
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func createAccount() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password cannot be empty."
            return
        }
        
        if let _ = UserDefaults.standard.string(forKey: username) {
            errorMessage = "Username already exists."
        } else {
            let hashedPassword = hashPassword(password)
            UserDefaults.standard.set(hashedPassword, forKey: username)
            isLoggedIn = true
            errorMessage = ""
        }
    }
    
    private func signIn() {
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password cannot be empty."
            return
        }
        
        if let storedHashedPassword = UserDefaults.standard.string(forKey: username) {
            let hashedPassword = hashPassword(password)
            if hashedPassword == storedHashedPassword {
                isLoggedIn = true
                errorMessage = ""
            } else {
                errorMessage = "Incorrect password."
            }
        } else {
            errorMessage = "Account does not exist."
        }
    }
    
    private func hashPassword(_ password: String) -> String {
        let hashed = SHA256.hash(data: Data(password.utf8))
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
