// duotimeApp.swift

import SwiftUI

struct MenuBarContent: View {
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Button("Change Timezone") {
            openWindow(id: "settings")
        }
        .keyboardShortcut(",", modifiers: .command)

        Divider()

        Button("Quit duotime") {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q", modifiers: .command)
    }
}

@main
struct duotimeApp: App {
    @StateObject private var timeViewModel = TimeViewModel()

    var body: some Scene {
        // menu bar
        MenuBarExtra {
            MenuBarContent()
        } label: {
            Text(timeViewModel.currentTime)
                .font(.system(.body, design: .monospaced))
        }

        // settings window
        Window("Settings", id: "settings") {
            SettingsView(timeViewModel: timeViewModel)
        }
        .windowResizability(.contentSize)
        .windowStyle(.titleBar)
        .defaultSize(width: 400, height: 300)
    }
}
