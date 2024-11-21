import SwiftUI

struct PasscodePromptView: View {
    @Binding var enteredPasscode: String
    var onUnlock: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack {
            Text("Enter Passcode")
                .font(.headline)
                .padding()

            SecureField("Passcode", text: $enteredPasscode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button(action: onCancel) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    onUnlock()
                }) {
                    Text("Unlock")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding()
    }
}
