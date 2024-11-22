import SwiftUI
import LocalAuthentication

struct PasswordListView: View {
    @Binding var savedPasswords: [PasswordEntry]
    @AppStorage("AppPasscode") private var savedPasscode: String = ""
    @AppStorage("loggedInUsername") private var loggedInUsername: String = ""
    @State private var showPasscodePrompt: Bool = false
    @State private var enteredPasscode: String = ""
    @State private var currentIndexToUnlock: Int? = nil
    @State private var selectedPassword: PasswordEntry? = nil



    var body: some View {
        VStack {
            Text("Saved Passwords")
                .font(.largeTitle)
                .padding()

            List {
                ForEach(savedPasswords.indices, id: \.self) { index in
                    let entry = savedPasswords[index]

                    VStack(alignment: .leading) {
                        Text(entry.serviceName)
                            .font(.headline)

                        Text("Website: \(entry.website)")
                        Text("Username: \(entry.username)")
                        Text("Email: \(entry.email)")

                        if entry.passwordHidden {
                            Text("Password: ********")
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    authenticateToTogglePassword(for: index)
                                }
                        } else {
                            Text("Password: \(entry.password)")
                                .foregroundColor(.gray)
                        }

                        // View Details Button
                        Button(action: {
                            showPasswordDetails(for: entry)
                        }) {
                            Text("View Details")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 5)
                    }
                }
                .onDelete(perform: deletePassword)
            }
        }
        .sheet(item: $selectedPassword) { selectedPassword in
            PasswordDetailView(
                password: Binding(
                    get: { selectedPassword },
                    set: { updatedPassword in
                        if let index = savedPasswords.firstIndex(where: { $0.id == updatedPassword.id }) {
                            savedPasswords[index] = updatedPassword
                            PasswordManager.savePasswords(savedPasswords, for: loggedInUsername) //
                        }
                    }
                ),
                onClose: {
                    self.selectedPassword = nil // Ensure this is properly mutable
                }
            )
        }

        .sheet(isPresented: $showPasscodePrompt) {
            PasscodePromptView(
                enteredPasscode: $enteredPasscode,
                onUnlock: {
                    if let index = currentIndexToUnlock {
                        togglePasswordVisibility(for: index)
                        cancelPasscodeEntry()
                    }
                },
                onCancel: cancelPasscodeEntry
            )
        }
    }

    private func authenticateToTogglePassword(for index: Int) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to view the password") { success, _ in
                if success {
                    DispatchQueue.main.async {
                        togglePasswordVisibility(for: index)
                    }
                } else {
                    DispatchQueue.main.async {
                        fallbackToPasscodePrompt(for: index)
                    }
                }
            }
        } else {
            fallbackToPasscodePrompt(for: index)
        }
    }

    private func togglePasswordVisibility(for index: Int) {
        guard savedPasswords[index].passwordHidden else { return }
        savedPasswords[index].passwordHidden = false
        PasswordManager.savePasswords(savedPasswords, for: loggedInUsername)

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            savedPasswords[index].passwordHidden = true
            PasswordManager.savePasswords(savedPasswords, for: loggedInUsername)
        }
    }

    private func fallbackToPasscodePrompt(for index: Int) {
        currentIndexToUnlock = index
        showPasscodePrompt = true
    }

    private func cancelPasscodeEntry() {
        enteredPasscode = ""
        currentIndexToUnlock = nil
        showPasscodePrompt = false
    }

    private func deletePassword(at offsets: IndexSet) {
        savedPasswords.remove(atOffsets: offsets)
        PasswordManager.savePasswords(savedPasswords, for: loggedInUsername)
    }

    private func showPasswordDetails(for password: PasswordEntry) {
        selectedPassword = password
    }
}
