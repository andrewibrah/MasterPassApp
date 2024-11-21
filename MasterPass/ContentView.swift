// ContentView.swift
// Handles the main user interface and navigation between main content and login view.

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("loggedInUsername") private var loggedInUsername: String = ""
    @State private var showCreatePassword = false
    @State private var showSavedPasswords = false
    @State private var showPasscodeManager = false
    @State private var savedPasswords: [PasswordEntry] = []

    var body: some View {
        Group {
            if isLoggedIn {
                mainView
            } else {
                LoginView()
            }
        }
        .onAppear(perform: loadPasswords)
    }

    // MARK: - Main View for Logged-in Users

    private var mainView: some View {
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

                // Create Password Button
                Button(action: {
                    showCreatePassword.toggle()
                }) {
                    Text("Create Password")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .sheet(isPresented: $showCreatePassword) {
                    PasswordFormView(savedPasswords: $savedPasswords)
                        .onDisappear {
                            PasswordManager.savePasswords(savedPasswords, for: loggedInUsername)
                        }
                }

                // Saved Passwords Button
                Button(action: {
                    showSavedPasswords.toggle()
                }) {
                    Text("Saved Passwords")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .sheet(isPresented: $showSavedPasswords) {
                    PasswordListView(savedPasswords: $savedPasswords)
                }

             

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
        }
    }

    // MARK: - Functions

    private func loadPasswords() {
        PasswordManager.loadPasswords(for: loggedInUsername) { loadedPasswords in
            savedPasswords = loadedPasswords
        }
    }

    private func logOut() {
        // Clear user data and reset login state
        loggedInUsername = ""
        isLoggedIn = false
        savedPasswords.removeAll()
    }
}
