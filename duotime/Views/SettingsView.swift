//
//  SettingsView.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI
import Foundation
import AppKit

struct SettingsView: View {
    @ObservedObject var timeViewModel: TimeViewModel
    @State private var searchText: String = ""

    init(timeViewModel: TimeViewModel) {
        self.timeViewModel = timeViewModel
    }

    // Popular timezones similar to iOS World Clock with abbreviations
    private var popularTimezones: [TimezoneInfo] = [
        // Americas
        TimezoneInfo(identifier: "America/New_York", cityName: "New York", countryRegion: "United States", abbreviation: "EST/EDT"),
        TimezoneInfo(identifier: "America/Los_Angeles", cityName: "Los Angeles", countryRegion: "United States", abbreviation: "PST/PDT"),
        TimezoneInfo(identifier: "America/Chicago", cityName: "Chicago", countryRegion: "United States", abbreviation: "CST/CDT"),
        TimezoneInfo(identifier: "America/Denver", cityName: "Denver", countryRegion: "United States", abbreviation: "MST/MDT"),
        TimezoneInfo(identifier: "America/Toronto", cityName: "Toronto", countryRegion: "Canada", abbreviation: "EST/EDT"),
        TimezoneInfo(identifier: "America/Vancouver", cityName: "Vancouver", countryRegion: "Canada", abbreviation: "PST/PDT"),
        TimezoneInfo(identifier: "America/Mexico_City", cityName: "Mexico City", countryRegion: "Mexico"),
        TimezoneInfo(identifier: "America/Sao_Paulo", cityName: "São Paulo", countryRegion: "Brazil", abbreviation: "BRT/BRST"),
        TimezoneInfo(identifier: "America/Buenos_Aires", cityName: "Buenos Aires", countryRegion: "Argentina", abbreviation: "ART"),

        // Europe
        TimezoneInfo(identifier: "Europe/London", cityName: "London", countryRegion: "United Kingdom", abbreviation: "GMT/BST"),
        TimezoneInfo(identifier: "Europe/Paris", cityName: "Paris", countryRegion: "France", abbreviation: "CET/CEST"),
        TimezoneInfo(identifier: "Europe/Berlin", cityName: "Berlin", countryRegion: "Germany", abbreviation: "CET/CEST"),
        TimezoneInfo(identifier: "Europe/Rome", cityName: "Rome", countryRegion: "Italy", abbreviation: "CET/CEST"),
        TimezoneInfo(identifier: "Europe/Madrid", cityName: "Madrid", countryRegion: "Spain", abbreviation: "CET/CEST"),
        TimezoneInfo(identifier: "Europe/Amsterdam", cityName: "Amsterdam", countryRegion: "Netherlands", abbreviation: "CET/CEST"),
        TimezoneInfo(identifier: "Europe/Zurich", cityName: "Zurich", countryRegion: "Switzerland", abbreviation: "CET/CEST"),
        TimezoneInfo(identifier: "Europe/Stockholm", cityName: "Stockholm", countryRegion: "Sweden", abbreviation: "CET/CEST"),
        TimezoneInfo(identifier: "Europe/Moscow", cityName: "Moscow", countryRegion: "Russia", abbreviation: "MSK/MSD"),

        // Asia
        TimezoneInfo(identifier: "Asia/Tokyo", cityName: "Tokyo", countryRegion: "Japan", abbreviation: "JST"),
        TimezoneInfo(identifier: "Asia/Shanghai", cityName: "Shanghai", countryRegion: "China"),
        TimezoneInfo(identifier: "Asia/Hong_Kong", cityName: "Hong Kong", countryRegion: "Hong Kong", abbreviation: "HKT"),
        TimezoneInfo(identifier: "Asia/Singapore", cityName: "Singapore", countryRegion: "Singapore", abbreviation: "SGT"),
        TimezoneInfo(identifier: "Asia/Seoul", cityName: "Seoul", countryRegion: "South Korea", abbreviation: "KST"),
        TimezoneInfo(identifier: "Asia/Kolkata", cityName: "Mumbai", countryRegion: "India", abbreviation: "IST"),
        TimezoneInfo(identifier: "Asia/Kolkata", cityName: "Delhi", countryRegion: "India", abbreviation: "IST"),
        TimezoneInfo(identifier: "Asia/Dubai", cityName: "Dubai", countryRegion: "UAE", abbreviation: "GST"),
        TimezoneInfo(identifier: "Asia/Bangkok", cityName: "Bangkok", countryRegion: "Thailand", abbreviation: "ICT"),
        TimezoneInfo(identifier: "Asia/Manila", cityName: "Manila", countryRegion: "Philippines", abbreviation: "PHT"),

        // Pacific
        TimezoneInfo(identifier: "Australia/Sydney", cityName: "Sydney", countryRegion: "Australia"),
        TimezoneInfo(identifier: "Australia/Melbourne", cityName: "Melbourne", countryRegion: "Australia"),
        TimezoneInfo(identifier: "Pacific/Auckland", cityName: "Auckland", countryRegion: "New Zealand", abbreviation: "NZST/NZDT"),
        TimezoneInfo(identifier: "Pacific/Honolulu", cityName: "Honolulu", countryRegion: "Hawaii", abbreviation: "HST"),

        // Africa & Middle East
        TimezoneInfo(identifier: "Africa/Cairo", cityName: "Cairo", countryRegion: "Egypt"),
        TimezoneInfo(identifier: "Africa/Johannesburg", cityName: "Johannesburg", countryRegion: "South Africa"),
        TimezoneInfo(identifier: "Asia/Jerusalem", cityName: "Jerusalem", countryRegion: "Israel"),
        TimezoneInfo(identifier: "Asia/Tehran", cityName: "Tehran", countryRegion: "Iran", abbreviation: "IRST")
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
            let abbreviation = TimezoneInfo.getAbbreviationFromTimezone(identifier)

            return TimezoneInfo(identifier: identifier, cityName: cityName, countryRegion: region, abbreviation: abbreviation)
        }

        return popularTimezones + additionalTimezones
    }

    private var filteredTimezones: [TimezoneInfo] {
        let timezones = searchText.isEmpty ? popularTimezones : allTimezones

        if searchText.isEmpty {
            return timezones
        } else {
            let searchTerm = searchText.uppercased()
            return timezones.filter { timezone in
                timezone.cityName.localizedCaseInsensitiveContains(searchText) ||
                timezone.countryRegion.localizedCaseInsensitiveContains(searchText) ||
                timezone.identifier.localizedCaseInsensitiveContains(searchText) ||
                timezone.abbreviation?.localizedCaseInsensitiveContains(searchText) == true ||
                TimezoneInfo.abbreviationMapping.keys.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
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

    // Group timezones by region for better organization
    private var groupedTimezones: [String: [TimezoneInfo]] {
        var groups: [String: [TimezoneInfo]] = [:]

        for timezone in popularTimezones {
            let region: String
            switch timezone.identifier.split(separator: "/").first {
            case "America":
                region = "🌎 Americas"
            case "Europe":
                region = "🇪🇺 Europe"
            case "Asia":
                region = "🌏 Asia"
            case "Australia", "Pacific":
                region = "🏄 Pacific"
            case "Africa":
                region = "🌍 Africa & Middle East"
            default:
                region = "🌐 Other"
            }

            if groups[region] == nil {
                groups[region] = []
            }
            groups[region]?.append(timezone)
        }

        return groups
    }

    // Get selected timezone info from all available timezones
    private func getSelectedTimezoneInfo() -> TimezoneInfo? {
        return allTimezones.first { $0.identifier == timeViewModel.currentTimezone }
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color(NSColor.windowBackgroundColor), Color(NSColor.controlBackgroundColor)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Image(systemName: "clock")
                        .font(.title)
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text("duotime Settings")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Choose your favorite timezone")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.bottom, 8)

                // Search Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Search Timezones")
                        .font(.headline)
                        .foregroundColor(.primary)

                    ZStack(alignment: .trailing) {
                        TextField("Search by city, country, or abbreviation (EST, PST, IST)...", text: $searchText)
                            .textFieldStyle(.roundedBorder)
                            .padding(.vertical, 4)
                            .background(Color(NSColor.windowBackgroundColor))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)

                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // Results Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(searchText.isEmpty ? "🌍 Popular Cities" : "🔍 Search Results")
                            .font(.headline)
                            .foregroundColor(.primary)

                        Spacer()

                        Text("\(filteredTimezones.count) timezones")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color(NSColor.controlBackgroundColor))
                            .cornerRadius(8)
                    }

                    // Timezone List
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            if searchText.isEmpty {
                                // Group popular timezones by region
                                ForEach(groupedTimezones.keys.sorted(), id: \.self) { region in
                                    if let timezones = groupedTimezones[region] {
                                        Section(header:
                                            Text(region)
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.secondary)
                                                .padding(.vertical, 4)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color(NSColor.controlBackgroundColor))
                                                .cornerRadius(6)
                                        ) {
                                            ForEach(timezones, id: \.identifier) { timezone in
                                                TimezoneRow(timezone: timezone, timeViewModel: timeViewModel, currentTime: currentTime(for: timezone.identifier))
                                            }
                                        }
                                    }
                                }
                            } else {
                                // Show search results without grouping
                                ForEach(filteredTimezones, id: \.identifier) { timezone in
                                    TimezoneRow(timezone: timezone, timeViewModel: timeViewModel, currentTime: currentTime(for: timezone.identifier))
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .frame(height: 300)
                    .background(Color(NSColor.windowBackgroundColor))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                }

                // Selected Timezone Footer
                if let selectedTimezone = getSelectedTimezoneInfo() {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        VStack(alignment: .leading) {
                            Text("Currently Selected")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(selectedTimezone.cityName), \(selectedTimezone.countryRegion)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            if let abbreviation = selectedTimezone.abbreviation {
                                Text(abbreviation)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                        Spacer()
                        Text(currentTime(for: timeViewModel.currentTimezone))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding(24)
        }
        .frame(width: 500, height: 600)
    }
}

// Custom view for timezone rows
struct TimezoneRow: View {
    let timezone: TimezoneInfo
    @ObservedObject var timeViewModel: TimeViewModel
    let currentTime: String

    var body: some View {
        Button(action: {
            timeViewModel.updateTimezone(timezone.identifier)
        }) {
            HStack(spacing: 12) {
                // Time display
                VStack(alignment: .trailing, spacing: 2) {
                    Text(currentTime)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    if let abbreviation = timezone.abbreviation {
                        Text(abbreviation)
                            .font(.caption2)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                .frame(width: 80)

                // City and country info
                VStack(alignment: .leading, spacing: 2) {
                    Text(timezone.cityName)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(timezone.countryRegion)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Selection indicator
                if timezone.identifier == timeViewModel.currentTimezone {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                } else {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                timezone.identifier == timeViewModel.currentTimezone ?
                Color.green.opacity(0.1) : Color.clear
            )
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        timezone.identifier == timeViewModel.currentTimezone ?
                        Color.green.opacity(0.3) : Color.gray.opacity(0.2),
                        lineWidth: timezone.identifier == timeViewModel.currentTimezone ? 2 : 1
                    )
            )
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }
}
