//
//  TimeViewModel.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import Foundation
import Combine

class TimeViewModel: ObservableObject {
    @Published var currentTime: String = ""
    private var timezoneService: TimezoneServiceProtocol
    private var timer: Timer?

    var currentTimezone: String {
        timezoneService.selectedTimezone
    }

    init(timezoneService: TimezoneServiceProtocol = TimezoneService()) {
        self.timezoneService = timezoneService
        updateTime()
        startTimer()
    }

    private func formattedTime(_ date: Date = Date()) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: timezoneService.selectedTimezone)
        formatter.dateFormat = "h:mm:ss a"
        return formatter.string(from: date)
    }

    func updateTimezone(_ timezone: String) {
        timezoneService.selectedTimezone = timezone
        updateTime()
    }

    private func updateTime() {
        currentTime = formattedTime()
    }

    private func startTimer() {
        // Update every 1 second for real-time display with seconds
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTime()
        }
    }

    deinit {
        timer?.invalidate()
    }
}
