//
//  TimezoneFormatter.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import Foundation

struct TimezoneFormatter {
    static func formatTimezoneDisplay(_ timezoneIdentifier: String, popularTimezones: [TimezoneInfo]) -> String {
        if let timezone = popularTimezones.first(where: { $0.identifier == timezoneIdentifier }) {
            let timeZone = TimeZone(identifier: timezone.identifier)!
            let offset = timeZone.secondsFromGMT() / 3600
            let offsetString = offset >= 0 ? "+\(offset)" : "\(offset)"
            return "\(timezone.cityName) (UTC\(offsetString))"
        }
        // Fallback
        let timeZone = TimeZone(identifier: timezoneIdentifier)!
        let offset = timeZone.secondsFromGMT() / 3600
        let offsetString = offset >= 0 ? "+\(offset)" : "\(offset)"
        let cityName = timezoneIdentifier.split(separator: "/").last?.replacingOccurrences(of: "_", with: " ") ?? timezoneIdentifier
        return "\(cityName) (UTC\(offsetString))"
    }
}
