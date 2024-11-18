// PasswordDetailView for displaying detailed information about a password.
// Includes password unlocking within the detail view and a functional close button.

import SwiftUI
import LocalAuthentication

struct PasswordDetailView: View {
    @Binding var password: PasswordEntry
    @AppStorage("AppPasscode") private var savedPasscode: String = ""
    @State private var showPasscodePrompt: Bool = false
    @State private var enteredPasscode: String = ""
    @State private var showBiometricError: Bool = false
    var onClose: () -> Void

    var body: some View {
        VStack {
            Text(password.serviceName)
                .font(.largeTitle)
                .bold()
                .padding()

            Form {
                Section(header: Text("Details")) {
                    HStack {
                        Text("Website:")
                        Spacer()
                        Text(password.website)
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Username:")
                        Spacer()
                        Text(password.username)
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Email:")
                        Spacer()
                        Text(password.email)
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Password:")
                        Spacer()
                        if password.passwordHidden {
                            Text("********")
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    authenticateToTogglePassword()
                                }
                        } else {
                            Text(password.password)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }

            Spacer()

            Button(action: onClose) {
                Text("Close")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
        .sheet(isPresented: $showPasscodePrompt) {
            PasscodePromptView(
                enteredPasscode: $enteredPasscode,
                onUnlock: {
                    togglePasswordVisibility()
                },
                onCancel: {
                    showPasscodePrompt = false
                    enteredPasscode = ""
                }
            )
        }
        .alert(isPresented: $showBiometricError) {
            Alert(
                title: Text("Authentication Failed"),
                message: Text("Biometric authentication was not successful. Please try again."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func authenticateToTogglePassword() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to view the password") { success, _ in
                if success {
                    DispatchQueue.main.async {
                        togglePasswordVisibility()
                    }
                } else {
                    DispatchQueue.main.async {
                        showBiometricError = true
                    }
                }
            }
        } else {
            // Fallback to passcode if biometrics are unavailable
            showPasscodePrompt = true
        }
    }

    private func togglePasswordVisibility() {
        password.passwordHidden.toggle()
        showPasscodePrompt = false
    }
}
