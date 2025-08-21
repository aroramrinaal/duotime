//
//  duotimeApp.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI

class TimeViewModel: ObservableObject {
    @Published var currentNYCTime: String = ""
    private var timer: Timer?

    private func formattedNYCTime(_ date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        formatter.dateFormat = "h:mm:ss a"
        return formatter.string(from: date)
    }

    init() {
        updateTime()
        startTimer()
    }

    private func updateTime() {
        currentNYCTime = formattedNYCTime()
    }

    private func startTimer() {
        // Update every 1 second for real-time display with seconds
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTime()
        }
    }

    deinit {
        timer?.invalidate()
    }
}

@main
struct duotimeApp: App {

    @StateObject private var timeViewModel = TimeViewModel()
    
    var body: some Scene {
        MenuBarExtra {
            VStack {
                Button("Quit duotime") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding()
        } label: {
            Text(timeViewModel.currentNYCTime)
                .font(.system(.body, design: .monospaced))
        }
    }
}
