//
//  LaunchAtLoginService.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import Foundation
import ServiceManagement

class LaunchAtLoginService {
    static let shared = LaunchAtLoginService()

    private init() {}

    func toggleLaunchAtLogin(enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to \(enabled ? "enable" : "disable") launch at login: \(error)")
            }
        } else {
            let bundleIdentifier = Bundle.main.bundleIdentifier!
            if enabled {
                SMLoginItemSetEnabled(bundleIdentifier as CFString, true)
            } else {
                SMLoginItemSetEnabled(bundleIdentifier as CFString, false)
            }
        }
    }
}
