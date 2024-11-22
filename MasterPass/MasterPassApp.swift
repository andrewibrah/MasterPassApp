import SwiftUI

// Launch Screen View with a red background and the app title.
struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            Text("MasterPass")
                .font(.system(size: 50, weight: .bold)) // Adjusted font size for better scaling.
                .foregroundColor(.white)
        }
    }
}

@main
struct MasterPassApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var showLaunchScreen = true

    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                LaunchScreenView()
                    .onAppear {
                        // Automatically transition to the main view after 2 seconds.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showLaunchScreen = false
                        }
                    }
            } else {
                // Determine whether to show the login or main content view.
                if isLoggedIn {
                    ContentView()
                } else {
                    LoginView()
                }
            }
        }
    }
}
