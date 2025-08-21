//
//  duotimeApp.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI

@main
struct duotimeApp: App {
    
    private func formattedNYCTime(_ date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    var body: some Scene {
        WindowGroup {
            VStack {
                Text("duotime is running in the menu bar")
                    .padding()
                Text("You can close this window")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(width: 300, height: 100)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        
        MenuBarExtra("duotime", systemImage: "clock") {
            VStack {
                Text("duotime")
                    .font(.headline)
                
                TimelineView(.periodic(from: .now, by: 60)) { context in
                    Text(formattedNYCTime(context.date))
                        .font(.monospaced(.body)())
                }
                
                Divider()
                
                Button("Quit duotime") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding()
        }
    }
}
