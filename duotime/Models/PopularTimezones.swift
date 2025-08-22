//
//  PopularTimezones.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import Foundation

struct PopularTimezones {
    static let all: [TimezoneInfo] = [
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
}
