//
//  duotimeApp.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI

@main
struct duotimeApp: App {

    @StateObject private var timeViewModel = TimeViewModel()
    
    var body: some Scene {
                        MenuBarExtra {
            SettingsLink {
                Text("Change Timezone")
            }

            Divider()

            Button("Quit duotime") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            Text(timeViewModel.currentTime)
                .font(.system(.body, design: .monospaced))
        }
        
        Settings {
            SettingsView(timeViewModel: timeViewModel)
        }
    }
}
