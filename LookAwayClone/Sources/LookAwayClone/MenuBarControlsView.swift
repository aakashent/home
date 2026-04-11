import SwiftUI

struct MenuBarControlsView: View {
    @EnvironmentObject private var model: BreakTimerModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("LookAway")
                .font(.headline)

            Text(model.isBreakActive ? "Break in progress" : "Next break in \(model.timerLabel)")
                .foregroundStyle(.secondary)

            HStack {
                Button(model.isRunning ? "Pause" : "Start") {
                    model.isRunning ? model.pause() : model.start()
                }

                Button("Reset") {
                    model.pause()
                    model.resetForFocusBlock()
                }
            }

            Divider()

            Text("Focus \(Int(model.focusMinutes)) min • Break \(Int(model.breakSeconds)) sec")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(14)
    }
}
