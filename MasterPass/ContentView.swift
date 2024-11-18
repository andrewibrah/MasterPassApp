import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var showCreatePassword = false
    @State private var showSavedPasswords = false
    @State private var showPasscodeManager = false
    
    @State private var savedPasswords: [PasswordEntry] = []

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to MasterPass")
                .font(.largeTitle)
                .padding()

            // Button to Create Password
            Button(action: {
                showCreatePassword.toggle()
            }) {
                Text("Create Password")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .sheet(isPresented: $showCreatePassword) {
                PasswordFormView(savedPasswords: $savedPasswords)
            }

            // Button to View Saved Passwords
            Button(action: {
                showSavedPasswords.toggle()
            }) {
                Text("Saved Passwords")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .sheet(isPresented: $showSavedPasswords) {
                PasswordListView(savedPasswords: $savedPasswords)
            }

            // Button to Manage Passcode
            Button(action: {
                showPasscodeManager.toggle()
            }) {
                Text("Create/Edit Passcode")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .sheet(isPresented: $showPasscodeManager) {
                PasscodeSettingsView()
            }

            Spacer()

            // Log Out Button
            Button(action: logOut) {
                Text("Log Out")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding()
        .onAppear(perform: loadPasswords)
    }
    
    private func loadPasswords() {
        PasswordManager.loadPasswords { loadedPasswords in
            savedPasswords = loadedPasswords
        }
    }
    
    private func logOut() {
        isLoggedIn = false
    }
}
