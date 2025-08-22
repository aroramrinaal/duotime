//
//  AppBehaviorSectionView.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI

struct AppBehaviorSectionView: View {
    @Binding var launchAtLogin: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("App Behavior")
                    .font(.headline)
                Spacer()
            }

            VStack(spacing: 0) {
                HStack {
                    Text("Launch at login")
                    Spacer()
                    Toggle("", isOn: $launchAtLogin)
                        .onChange(of: launchAtLogin) { _, newValue in
                            LaunchAtLoginService.shared.toggleLaunchAtLogin(enabled: newValue)
                        }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .groupPanel() // rounded border
        }
    }
}
