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

    private var focusTask: Task<Void, Never>?
    private var breakTask: Task<Void, Never>?

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

        breakTask?.cancel()
        breakTask = nil

        focusTask?.cancel()

        isRunning = true

        focusTask = Task { [weak self] in
            guard let self else { return }

            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                guard self.isRunning, !self.isBreakActive else { continue }

                if self.secondsRemaining > 0 {
                    self.secondsRemaining -= 1
                } else {
                    self.beginBreak()
                }
            }
        }
    }

    func pause() {
        isRunning = false
    }

    func resetForFocusBlock() {
        breakTask?.cancel()
        breakTask = nil

        secondsRemaining = Int(focusMinutes * 60)
        isBreakActive = false
    }

    func skipBreak() {
        breakTask?.cancel()
        breakTask = nil

        isBreakActive = false
        resetForFocusBlock()
        start()
    }

    func beginBreak() {
        guard !isBreakActive else { return }

        focusTask?.cancel()
        focusTask = nil

        isBreakActive = true
        isRunning = false

        NSSound.beep()

        breakTask?.cancel()
        breakTask = Task { [weak self] in
            guard let self else { return }

            try? await Task.sleep(for: .seconds(Int(self.breakSeconds)))
            guard !Task.isCancelled, self.isBreakActive else { return }
            self.skipBreak()
        }
    }

    deinit {
        focusTask?.cancel()
        breakTask?.cancel()
    }
}
