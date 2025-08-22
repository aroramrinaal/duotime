//
//  TimezoneInfo.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import Foundation

struct TimezoneInfo {
    // Static mapping of timezone abbreviations to identifiers
    static let abbreviationMapping: [String: String] = [
        "ADT": "America/Halifax",
        "AKDT": "America/Juneau",
        "AKST": "America/Juneau",
        "ART": "America/Argentina/Buenos_Aires",
        "AST": "America/Halifax",
        "BDT": "Asia/Dhaka",
        "BRST": "America/Sao_Paulo",
        "BRT": "America/Sao_Paulo",
        "BST": "Europe/London",
        "CAT": "Africa/Harare",
        "CDT": "America/Chicago",
        "CEST": "Europe/Paris",
        "CET": "Europe/Paris",
        "CLST": "America/Santiago",
        "CLT": "America/Santiago",
        "COT": "America/Bogota",
        "CST": "America/Chicago",
        "EAT": "Africa/Addis_Ababa",
        "EDT": "America/New_York",
        "EEST": "Europe/Istanbul",
        "EET": "Europe/Istanbul",
        "EST": "America/New_York",
        "GMT": "Europe/London",
        "GST": "Asia/Dubai",
        "HKT": "Asia/Hong_Kong",
        "HST": "Pacific/Honolulu",
        "ICT": "Asia/Bangkok",
        "IRST": "Asia/Tehran",
        "IST": "Asia/Kolkata",
        "JST": "Asia/Tokyo",
        "KST": "Asia/Seoul",
        "MDT": "America/Denver",
        "MSD": "Europe/Moscow",
        "MSK": "Europe/Moscow",
        "MST": "America/Denver",
        "NZDT": "Pacific/Auckland",
        "NZST": "Pacific/Auckland",
        "PDT": "America/Los_Angeles",
        "PET": "America/Lima",
        "PHT": "Asia/Manila",
        "PKT": "Asia/Karachi",
        "PST": "America/Los_Angeles",
        "SGT": "Asia/Singapore",
        "UTC": "Europe/London",
        "WAT": "Africa/Lagos",
        "WEST": "Europe/Lisbon",
        "WET": "Europe/Lisbon",
        "WIT": "Asia/Jakarta"
    ]

    // Helper function to get timezone identifier from abbreviation
    static func getTimezoneFromAbbreviation(_ abbreviation: String) -> String? {
        return abbreviationMapping[abbreviation.uppercased()]
    }

    // Helper function to get abbreviation from timezone identifier
    static func getAbbreviationFromTimezone(_ timezoneIdentifier: String) -> String? {
        return abbreviationMapping.first(where: { $0.value == timezoneIdentifier })?.key
    }
    let identifier: String
    let cityName: String
    let countryRegion: String
    let abbreviation: String?

    init(identifier: String, cityName: String, countryRegion: String, abbreviation: String? = nil) {
        self.identifier = identifier
        self.cityName = cityName
        self.countryRegion = countryRegion
        self.abbreviation = abbreviation
    }

    var displayName: String {
        "\(cityName), \(countryRegion)"
    }
}
