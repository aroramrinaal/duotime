// duotimeApp.swift

import SwiftUI

struct MenuBarContent: View {
    @Environment(\.openWindow) private var openWindow
    @AppStorage("useDefaultTitlebar") private var useDefaultTitlebar = false

    var body: some View {
        Button("Change Timezone") {
            openWindow(id: useDefaultTitlebar ? "settingsDefault" : "settingsHidden")
        }

        Divider()

        Button("Quit duotime") {
            NSApplication.shared.terminate(nil)
        }
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

        // default title bar version
        Window("Settings", id: "settingsDefault") {
            SettingsView(timeViewModel: timeViewModel)
        }
        .windowResizability(.contentSize)
        .windowStyle(TitleBarWindowStyle())
        .defaultSize(width: 400, height: 340)

        // hidden title bar version
        Window("Settings", id: "settingsHidden") {
            SettingsView(timeViewModel: timeViewModel)
        }
        .windowResizability(.contentSize)
        .windowStyle(HiddenTitleBarWindowStyle())
        .defaultSize(width: 400, height: 320)
    }
}
