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
    @State private var searchText: String = ""

    init(timeViewModel: TimeViewModel) {
        self.timeViewModel = timeViewModel
    }

    // Popular timezones similar to iOS World Clock
    private var popularTimezones: [TimezoneInfo] = [
        // Americas
        TimezoneInfo(identifier: "America/New_York", cityName: "New York", countryRegion: "United States"),
        TimezoneInfo(identifier: "America/Los_Angeles", cityName: "Los Angeles", countryRegion: "United States"),
        TimezoneInfo(identifier: "America/Chicago", cityName: "Chicago", countryRegion: "United States"),
        TimezoneInfo(identifier: "America/Denver", cityName: "Denver", countryRegion: "United States"),
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

    private var allTimezones: [TimezoneInfo] {
        let allIds = TimeZone.knownTimeZoneIdentifiers.sorted()
        let popularIds = Set(popularTimezones.map { $0.identifier })

        let additionalTimezones = allIds.compactMap { identifier -> TimezoneInfo? in
            guard !popularIds.contains(identifier) else { return nil }

            let components = identifier.split(separator: "/")
            guard components.count >= 2 else { return nil }

            let region = String(components[0])
            let cityName = String(components.last ?? "").replacingOccurrences(of: "_", with: " ")

            return TimezoneInfo(identifier: identifier, cityName: cityName, countryRegion: region)
        }

        return popularTimezones + additionalTimezones
    }

    private var filteredTimezones: [TimezoneInfo] {
        let timezones = searchText.isEmpty ? popularTimezones : allTimezones

        if searchText.isEmpty {
            return timezones
        } else {
            return timezones.filter { timezone in
                timezone.cityName.localizedCaseInsensitiveContains(searchText) ||
                timezone.countryRegion.localizedCaseInsensitiveContains(searchText) ||
                timezone.identifier.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    private func currentTime(for identifier: String) -> String {
        let tz = TimeZone(identifier: identifier)
        let formatter = DateFormatter()
        formatter.timeZone = tz
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("duotime Settings")
                .font(.headline)
                .padding(.bottom, 8)

            Text("Choose your favorite timezone:")
                .foregroundStyle(.secondary)

            TextField("Search timezones...", text: $searchText)
                .textFieldStyle(.roundedBorder)

            if searchText.isEmpty {
                Text("Popular Cities:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            } else {
                Text("Search Results:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(filteredTimezones, id: \.identifier) { timezone in
                        Button(action: {
                            timeViewModel.updateTimezone(timezone.identifier)
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(timezone.cityName)
                                        .foregroundColor(.primary)
                                        .fontWeight(.medium)
                                    Text(timezone.countryRegion)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 2) {
                                    if timezone.identifier == timeViewModel.currentTimezone {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                            .fontWeight(.semibold)
                                    }
                                    Text(currentTime(for: timezone.identifier))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                timezone.identifier == timeViewModel.currentTimezone ?
                                Color.blue.opacity(0.1) : Color.clear
                            )
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .frame(height: 320)

            HStack {
                Text("Selected:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                if let selectedTimezoneInfo = popularTimezones.first(where: { $0.identifier == timeViewModel.currentTimezone }) {
                    Text("\(selectedTimezoneInfo.displayName)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text(timeViewModel.currentTimezone.replacingOccurrences(of: "_", with: " "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .frame(width: 400, height: 450)
    }
}
