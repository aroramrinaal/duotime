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
    @Published var use24HourTime = false {
        didSet {
            updateTimeFormat()
        }
    }
    @Published var prefixText = "" {
        didSet {
            updateTimeFormat()
        }
    }
    private var timezoneService: TimezoneServiceProtocol
    private var timer: Timer?

    var currentTimezone: String {
        timezoneService.selectedTimezone
    }

    init(timezoneService: TimezoneServiceProtocol = TimezoneService()) {
        self.timezoneService = timezoneService
        updateTimeFormat()
        startTimer()
    }

    private func updateTimeFormat() {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: currentTimezone)

        if use24HourTime {
            formatter.dateFormat = "HH:mm:ss"
        } else {
            formatter.dateFormat = "h:mm:ss a"
        }

        let timeString = formatter.string(from: Date())
        currentTime = prefixText.isEmpty ? timeString : "\(prefixText) \(timeString)"
    }

    func updateTimezone(_ timezone: String) {
        timezoneService.selectedTimezone = timezone
        updateTimeFormat()
    }

    private func startTimer() {
        // Update every 1 second for real-time display with seconds
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateTimeFormat()
        }
    }

    deinit {
        timer?.invalidate()
    }
}
