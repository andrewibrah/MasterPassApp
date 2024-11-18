import SwiftUI


struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            Text("Master Pass")
                .font(.system(size: 100, weight: .bold))
                .foregroundColor(.white)
        }
    }
}
@main
struct MasterPassApp: App {
    @State private var showLaunchScreen = true

    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showLaunchScreen = false
                        }
                    }
            } else {
                ContentView()
            }
        }
    }
}
