// ActivityTimer.swift
// Handles user activity timeout and resets based on user interactions.
import Foundation
import Combine

class ActivityTimer: ObservableObject {
    @Published var timeout: TimeInterval
    private var timer: Timer?

    init(timeout: TimeInterval = 300) { // Default to 5 minutes
        self.timeout = timeout
    }

    func startTimer() {
        resetTimer()
    }

    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { [weak self] _ in
            self?.timeoutReached()
        }
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }


    private func timeoutReached() {
        // Handle timeout action
        print("User timed out!")
    }
}
