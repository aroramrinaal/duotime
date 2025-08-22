//
//  SettingsView.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI
import Foundation

struct SettingsView: View {
    @ObservedObject var timeViewModel: TimeViewModel
    @State private var launchAtLogin = false
    @State private var use24HourTime = false
    @State private var prefixText = ""

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

    var body: some View {
        VStack(spacing: 0) {
            // Header with branding
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("duotime")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text("Second Clock Settings")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 32)

            VStack(spacing: 24) {
                // Launch at login
                HStack {
                    Text("Launch at login")
                        .font(.system(size: 14))
                    Spacer()
                    Toggle("", isOn: $launchAtLogin)
                        .toggleStyle(.switch)
                }
                .padding(.horizontal, 24)

                Divider()
                    .padding(.horizontal, 24)

                // 24-hour time
                HStack {
                    Text("24-hour time")
                        .font(.system(size: 14))
                    Spacer()
                    Toggle("", isOn: $use24HourTime)
                        .toggleStyle(.switch)
                }
                .padding(.horizontal, 24)

                Divider()
                    .padding(.horizontal, 24)

                // Time zone selection
                HStack {
                    Text("Time zone")
                        .font(.system(size: 14))
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
                        HStack {
                            Text(selectedTimezoneDisplay)
                                .font(.system(size: 14))
                                .foregroundColor(.primary)
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(NSColor.controlBackgroundColor))
                        .cornerRadius(6)
                    }
                    .menuStyle(.borderlessButton)
                }
                .padding(.horizontal, 24)

                Divider()
                    .padding(.horizontal, 24)

                // Prefix text
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Prefix text")
                            .font(.system(size: 14))
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        TextField("", text: $prefixText)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 14))
                            .padding(.horizontal, 24)
                        
                        Text("Tip: You could use a flag emoji")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 24)
                    }
                }
            }

            Spacer()
        }
        .frame(width: 480, height: 380)
        .background(Color(NSColor.windowBackgroundColor))
    }
}
