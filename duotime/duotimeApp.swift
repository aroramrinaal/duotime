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
            VStack(spacing: 12) {
                SettingsLink {
                    Text("Change Timezone")
                }
                .buttonStyle(.plain)
                .foregroundColor(.blue)
                
                Divider()
                
                Button("Quit duotime") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.plain)
            }
            .padding()
            .frame(width: 150)
        } label: {
            Text(timeViewModel.currentTime)
                .font(.system(.body, design: .monospaced))
        }
        .menuBarExtraStyle(.window)
        
        Settings {
            SettingsView(timeViewModel: timeViewModel)
        }
    }
}