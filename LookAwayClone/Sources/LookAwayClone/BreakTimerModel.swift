import Foundation
import SwiftUI
import AppKit

@MainActor
final class BreakTimerModel: ObservableObject {
    @Published var focusMinutes: Double = 20
    @Published var breakSeconds: Double = 20
    @Published var isRunning = false
    @Published var secondsRemaining: Int = 20 * 60
    @Published var isBreakActive = false

    private var task: Task<Void, Never>?

    var progress: Double {
        let total = max(1, Int(focusMinutes * 60))
        return Double(total - secondsRemaining) / Double(total)
    }

    var timerLabel: String {
        let minutes = secondsRemaining / 60
        let seconds = secondsRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    init() {
        resetForFocusBlock()
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true

        task = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard isRunning, !isBreakActive else { continue }

                if secondsRemaining > 0 {
                    secondsRemaining -= 1
                } else {
                    beginBreak()
                }
            }
        }
    }

    func pause() {
        isRunning = false
    }

    func resetForFocusBlock() {
        secondsRemaining = Int(focusMinutes * 60)
        isBreakActive = false
    }

    func skipBreak() {
        isBreakActive = false
        resetForFocusBlock()
        start()
    }

    func beginBreak() {
        guard !isBreakActive else { return }
        isBreakActive = true
        isRunning = false

        NSSound.beep()

        Task {
            try? await Task.sleep(for: .seconds(Int(breakSeconds)))
            skipBreak()
        }
    }

    deinit {
        task?.cancel()
    }
}
