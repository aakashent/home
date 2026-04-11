import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var model: BreakTimerModel

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("LookAway")
                    .font(.largeTitle.bold())
                Text("Protect your eyes with regular screen breaks.")
                    .foregroundStyle(.secondary)

                ProgressView(value: model.progress)
                    .tint(.mint)

                HStack {
                    StatPill(title: "Next break", value: model.timerLabel)
                    StatPill(title: "Focus", value: "\(Int(model.focusMinutes)) min")
                    StatPill(title: "Break", value: "\(Int(model.breakSeconds)) sec")
                }

                SettingsCard()

                HStack(spacing: 12) {
                    Button(model.isRunning ? "Pause" : "Start") {
                        model.isRunning ? model.pause() : model.start()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Reset") {
                        model.pause()
                        model.resetForFocusBlock()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(24)

            if model.isBreakActive {
                BreakOverlay(seconds: Int(model.breakSeconds)) {
                    model.skipBreak()
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: model.isBreakActive)
    }
}

private struct StatPill: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.bold())
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
    }
}

private struct SettingsCard: View {
    @EnvironmentObject private var model: BreakTimerModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Schedule")
                .font(.headline)

            VStack(alignment: .leading) {
                Text("Focus length: \(Int(model.focusMinutes)) minutes")
                Slider(value: $model.focusMinutes, in: 5...60, step: 5)
                    .onChange(of: model.focusMinutes) { _, _ in
                        model.resetForFocusBlock()
                    }
            }

            VStack(alignment: .leading) {
                Text("Break length: \(Int(model.breakSeconds)) seconds")
                Slider(value: $model.breakSeconds, in: 10...90, step: 5)
            }
        }
        .padding(16)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct BreakOverlay: View {
    let seconds: Int
    let onSkip: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "eye")
                .font(.system(size: 56))
                .foregroundStyle(.mint)
            Text("Look away from your screen")
                .font(.largeTitle.bold())
            Text("Take \(seconds) seconds to focus on something far away.")
                .font(.title3)
                .foregroundStyle(.secondary)

            Button("Skip break", action: onSkip)
                .buttonStyle(.bordered)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
    }
}
