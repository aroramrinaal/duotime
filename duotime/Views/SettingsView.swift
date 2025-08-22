//
//  SettingsView.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI
import Foundation
import ServiceManagement

struct SettingsView: View {
    @ObservedObject var timeViewModel: TimeViewModel
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("use24HourTime") private var use24HourTime = false

    @AppStorage("prefixText") private var prefixText = ""

    init(timeViewModel: TimeViewModel) {
        self.timeViewModel = timeViewModel
    }

    // Popular timezones for the dropdown
    private var popularTimezones: [TimezoneInfo] = [
        // Americas
        TimezoneInfo(identifier: "America/New_York", cityName: "New York", countryRegion: "United States"),
        TimezoneInfo(identifier: "America/Los_Angeles", cityName: "Los Angeles", countryRegion: "United States"),
        TimezoneInfo(identifier: "America/Chicago", cityName: "Chicago", countryRegion: "United States"),
        TimezoneInfo(identifier: "America/Denver", cityName: "Denver", countryRegion: "United States"),
        TimezoneInfo(identifier: "America/Phoenix", cityName: "Phoenix", countryRegion: "United States"),
        TimezoneInfo(identifier: "America/Toronto", cityName: "Toronto", countryRegion: "Canada"),
        TimezoneInfo(identifier: "America/Vancouver", cityName: "Vancouver", countryRegion: "Canada"),
        TimezoneInfo(identifier: "America/Mexico_City", cityName: "Mexico City", countryRegion: "Mexico"),
        TimezoneInfo(identifier: "America/Sao_Paulo", cityName: "São Paulo", countryRegion: "Brazil"),
        TimezoneInfo(identifier: "America/Buenos_Aires", cityName: "Buenos Aires", countryRegion: "Argentina"),

        // Europe
        TimezoneInfo(identifier: "Europe/London", cityName: "London", countryRegion: "United Kingdom"),
        TimezoneInfo(identifier: "Europe/Paris", cityName: "Paris", countryRegion: "France"),
        TimezoneInfo(identifier: "Europe/Berlin", cityName: "Berlin", countryRegion: "Germany"),
        TimezoneInfo(identifier: "Europe/Rome", cityName: "Rome", countryRegion: "Italy"),
        TimezoneInfo(identifier: "Europe/Madrid", cityName: "Madrid", countryRegion: "Spain"),
        TimezoneInfo(identifier: "Europe/Amsterdam", cityName: "Amsterdam", countryRegion: "Netherlands"),
        TimezoneInfo(identifier: "Europe/Zurich", cityName: "Zurich", countryRegion: "Switzerland"),
        TimezoneInfo(identifier: "Europe/Stockholm", cityName: "Stockholm", countryRegion: "Sweden"),
        TimezoneInfo(identifier: "Europe/Moscow", cityName: "Moscow", countryRegion: "Russia"),

        // Asia
        TimezoneInfo(identifier: "Asia/Tokyo", cityName: "Tokyo", countryRegion: "Japan"),
        TimezoneInfo(identifier: "Asia/Shanghai", cityName: "Shanghai", countryRegion: "China"),
        TimezoneInfo(identifier: "Asia/Hong_Kong", cityName: "Hong Kong", countryRegion: "Hong Kong"),
        TimezoneInfo(identifier: "Asia/Singapore", cityName: "Singapore", countryRegion: "Singapore"),
        TimezoneInfo(identifier: "Asia/Seoul", cityName: "Seoul", countryRegion: "South Korea"),
        TimezoneInfo(identifier: "Asia/Kolkata", cityName: "Mumbai", countryRegion: "India"),
        TimezoneInfo(identifier: "Asia/Dubai", cityName: "Dubai", countryRegion: "UAE"),
        TimezoneInfo(identifier: "Asia/Bangkok", cityName: "Bangkok", countryRegion: "Thailand"),
        TimezoneInfo(identifier: "Asia/Manila", cityName: "Manila", countryRegion: "Philippines"),

        // Pacific
        TimezoneInfo(identifier: "Australia/Sydney", cityName: "Sydney", countryRegion: "Australia"),
        TimezoneInfo(identifier: "Australia/Melbourne", cityName: "Melbourne", countryRegion: "Australia"),
        TimezoneInfo(identifier: "Pacific/Auckland", cityName: "Auckland", countryRegion: "New Zealand"),
        TimezoneInfo(identifier: "Pacific/Honolulu", cityName: "Honolulu", countryRegion: "Hawaii"),

        // Africa & Middle East
        TimezoneInfo(identifier: "Africa/Cairo", cityName: "Cairo", countryRegion: "Egypt"),
        TimezoneInfo(identifier: "Africa/Johannesburg", cityName: "Johannesburg", countryRegion: "South Africa"),
        TimezoneInfo(identifier: "Asia/Jerusalem", cityName: "Jerusalem", countryRegion: "Israel"),
        TimezoneInfo(identifier: "Asia/Tehran", cityName: "Tehran", countryRegion: "Iran")
    ]

    private var selectedTimezoneDisplay: String {
        if let timezone = popularTimezones.first(where: { $0.identifier == timeViewModel.currentTimezone }) {
            let timeZone = TimeZone(identifier: timezone.identifier)!
            let offset = timeZone.secondsFromGMT() / 3600
            let offsetString = offset >= 0 ? "+\(offset)" : "\(offset)"
            return "\(timezone.cityName) (UTC\(offsetString))"
        }
        // Fallback for timezones not in our popular list
        let timeZone = TimeZone(identifier: timeViewModel.currentTimezone)!
        let offset = timeZone.secondsFromGMT() / 3600
        let offsetString = offset >= 0 ? "+\(offset)" : "\(offset)"
        let cityName = timeViewModel.currentTimezone.split(separator: "/").last?.replacingOccurrences(of: "_", with: " ") ?? timeViewModel.currentTimezone
        return "\(cityName) (UTC\(offsetString))"
    }
    
    private func toggleLaunchAtLogin() {
        if #available(macOS 13.0, *) {
            do {
                if launchAtLogin {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to \(launchAtLogin ? "enable" : "disable") launch at login: \(error)")
            }
        } else {
            // Fallback for older macOS versions
            let bundleIdentifier = Bundle.main.bundleIdentifier!
            if launchAtLogin {
                SMLoginItemSetEnabled(bundleIdentifier as CFString, true)
            } else {
                SMLoginItemSetEnabled(bundleIdentifier as CFString, false)
            }
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Launch at login
            HStack {
                Text("Launch at login")
                Spacer()
                Toggle("", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { _, _ in
                        toggleLaunchAtLogin()
                    }
            }
            .padding(.vertical, 4)

            Divider()

            // 24-hour time
            HStack {
                Text("24-hour time")
                Spacer()
                Toggle("", isOn: $use24HourTime)
                    .onChange(of: use24HourTime) { _, newValue in
                        timeViewModel.use24HourTime = newValue
                    }
            }
            .padding(.vertical, 4)

            Divider()

            // Time zone selection
            HStack {
                Text("Time zone")
                Spacer()
                Menu {
                    ForEach(popularTimezones, id: \.identifier) { timezone in
                        Button {
                            timeViewModel.updateTimezone(timezone.identifier)
                        } label: {
                            let timeZone = TimeZone(identifier: timezone.identifier)!
                            let offset = timeZone.secondsFromGMT() / 3600
                            let offsetString = offset >= 0 ? "+\(offset)" : "\(offset)"
                            Text("\(timezone.cityName) (UTC\(offsetString))")
                        }
                    }
                } label: {
                    Text(selectedTimezoneDisplay)
                        .frame(maxWidth: 200)
                }
            }
            .padding(.vertical, 4)

            Divider()

            // Prefix text
            HStack(alignment: .top) {
                Text("Prefix text")
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    TextField("Optional (e.g. 🇺🇸)", text: $prefixText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                        .onChange(of: prefixText) { _, newValue in
                            timeViewModel.prefixText = newValue
                        }
                    
                    Text("Tip: Use a flag emoji")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .padding()
        .frame(width: 400, height: 300)
        .onAppear {
            // Initialize settings from TimeViewModel
            use24HourTime = timeViewModel.use24HourTime
            prefixText = timeViewModel.prefixText
        }
    }
}
