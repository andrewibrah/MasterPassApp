// Allows users to create, update, and manage their 4-digit passcode for app security.
// Handles passcode verification and ensures secure storage using UserDefaults.

import SwiftUI

struct PasscodeSettingsView: View {
    var isChangingPasscode: Bool = false
    @State private var oldPasscode: String = ""
    @State private var newPasscode: String = ""
    @State private var confirmPasscode: String = ""
    @State private var errorMessage: String = ""
    @AppStorage("AppPasscode") private var savedPasscode: String = ""
    @Environment(\.presentationMode) var presentationMode  // To close the sheet

    var body: some View {
        VStack {
            Text(savedPasscode.isEmpty ? "Create Passcode" : "Change Passcode")
                .font(.headline)
                .padding()

            if !savedPasscode.isEmpty {
                SecureField("Enter Old Passcode", text: $oldPasscode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            SecureField("Enter New Passcode", text: $newPasscode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Confirm New Passcode", text: $confirmPasscode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: savePasscode) {
                Text("Save Passcode")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
    }

    private func savePasscode() {
        if !savedPasscode.isEmpty {
            guard oldPasscode == savedPasscode else {
                errorMessage = "Old passcode is incorrect."
                return
            }
        }

        guard newPasscode == confirmPasscode, newPasscode.count == 4 else {
            errorMessage = "Passcode must be 4 digits and match."
            return
        }

        savedPasscode = newPasscode
        errorMessage = ""

        // Close the window after saving the passcode
        presentationMode.wrappedValue.dismiss()
    }
}
