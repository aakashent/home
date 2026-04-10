import SwiftUI

@main
struct LookAwayCloneApp: App {
    @StateObject private var timerModel = BreakTimerModel()

    var body: some Scene {
        MenuBarExtra("LookAway", systemImage: "eye") {
            MenuBarControlsView()
                .environmentObject(timerModel)
                .frame(width: 320)
        }

        Window("LookAway", id: "main") {
            DashboardView()
                .environmentObject(timerModel)
                .frame(minWidth: 560, minHeight: 430)
        }
        .windowResizability(.contentSize)
    }
}
