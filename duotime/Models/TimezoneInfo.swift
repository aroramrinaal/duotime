//
//  TimezoneInfo.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import Foundation

struct TimezoneInfo {
    let identifier: String
    let cityName: String
    let countryRegion: String

    var displayName: String {
        "\(cityName), \(countryRegion)"
    }
}
