//
//  TimezoneService.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI

protocol TimezoneServiceProtocol {
    var selectedTimezone: String { get set }
}

class TimezoneService: TimezoneServiceProtocol {
    @AppStorage("selectedTimezone") var selectedTimezone: String = "America/New_York"
}
