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
                    TextRow(label: "Website:", value: password.website)
                    TextRow(label: "Username:", value: password.username)
                    TextRow(label: "Email:", value: password.email)
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
            showPasscodePrompt = true // Fallback to passcode
        }
    }

    private func togglePasswordVisibility() {
        password.passwordHidden.toggle()
        PasswordManager.savePasswords([password], for: "") // Update the password visibility

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            password.passwordHidden = true
            PasswordManager.savePasswords([password], for: "") // Auto-hide after timeout
        }
    }

    private struct TextRow: View {
        let label: String
        let value: String

        var body: some View {
            HStack {
                Text(label)
                Spacer()
                Text(value)
                    .foregroundColor(.gray)
            }
        }
    }
}
