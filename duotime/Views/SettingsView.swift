//
//  SettingsView.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI
import Foundation
import ServiceManagement
import AppKit   // for Color(nsColor:) and NSViewRepresentable

struct SettingsView: View {
    @ObservedObject var timeViewModel: TimeViewModel
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("use24HourTime") private var use24HourTime = false
    @AppStorage("prefixText") private var prefixText = ""

    init(timeViewModel: TimeViewModel) {
        self.timeViewModel = timeViewModel
    }





    var body: some View {
        VStack(spacing: 20) {
            // App Behavior
            AppBehaviorSectionView(launchAtLogin: $launchAtLogin)

            // Time Display + Timezone
            TimeDisplaySectionView(
                timeViewModel: timeViewModel,
                use24HourTime: $use24HourTime,
                prefixText: $prefixText
            )
        }
        .padding(20)
        .frame(width: 400, height: 320)
        // keep the window on the darker system control background
        .background(Color(NSColor.controlBackgroundColor))
        .onAppear {
            use24HourTime = timeViewModel.use24HourTime
            prefixText = timeViewModel.prefixText
        }
    }
}




