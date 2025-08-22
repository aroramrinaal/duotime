//
//  duotimeApp.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI

struct MenuBarContent: View {
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        Button("Change Timezone") {
            openWindow(id: "settings")
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
        MenuBarExtra {
            MenuBarContent()
        } label: {
            Text(timeViewModel.currentTime)
                .font(.system(.body, design: .monospaced))
        }
        
        WindowGroup("Settings", id: "settings") {
            SettingsView(timeViewModel: timeViewModel)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 400, height: 280)
    }
}
