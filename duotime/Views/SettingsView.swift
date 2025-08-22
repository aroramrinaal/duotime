//
//  SettingsView.swift
//  duotime
//
//  Created by Mrinaal Arora on 8/21/25.
//

import SwiftUI
import Foundation
import ServiceManagement
import AppKit   // needed for NSViewRepresentable text field without focus ring

struct SettingsView: View {
    @ObservedObject var timeViewModel: TimeViewModel
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("use24HourTime") private var use24HourTime = false
    @AppStorage("prefixText") private var prefixText = ""

    init(timeViewModel: TimeViewModel) {
        self.timeViewModel = timeViewModel
    }



    private var selectedTimezoneDisplay: String {
        if let timezone = PopularTimezones.all.first(where: { $0.identifier == timeViewModel.currentTimezone }) {
            let timeZone = TimeZone(identifier: timezone.identifier)!
            let offset = timeZone.secondsFromGMT() / 3600
            let offsetString = offset >= 0 ? "+\(offset)" : "\(offset)"
            return "\(timezone.cityName) (UTC\(offsetString))"
        }
        // Fallback
        let timeZone = TimeZone(identifier: timeViewModel.currentTimezone)!
        let offset = timeZone.secondsFromGMT() / 3600
        let offsetString = offset >= 0 ? "+\(offset)" : "\(offset)"
        let cityName = timeViewModel.currentTimezone.split(separator: "/").last?.replacingOccurrences(of: "_", with: " ") ?? timeViewModel.currentTimezone
        return "\(cityName) (UTC\(offsetString))"
    }

    private func toggleLaunchAtLogin() {
        if #available(macOS 13.0, *) {
            do {
                if launchAtLogin {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("Failed to \(launchAtLogin ? "enable" : "disable") launch at login: \(error)")
            }
        } else {
            let bundleIdentifier = Bundle.main.bundleIdentifier!
            if launchAtLogin {
                SMLoginItemSetEnabled(bundleIdentifier as CFString, true)
            } else {
                SMLoginItemSetEnabled(bundleIdentifier as CFString, false)
            }
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            // App Behavior
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("App Behavior")
                        .font(.headline)
                    Spacer()
                }

                VStack(spacing: 0) {
                    HStack {
                        Text("Launch at login")
                        Spacer()
                        Toggle("", isOn: $launchAtLogin)
                            .onChange(of: launchAtLogin) { _, _ in
                                toggleLaunchAtLogin()
                            }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }

            // Time Display + Timezone
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Time Display")
                        .font(.headline)
                    Spacer()
                }

                VStack(spacing: 0) {
                    // 24-hour time
                    HStack {
                        Text("24-hour time")
                        Spacer()
                        Toggle("", isOn: $use24HourTime)
                            .onChange(of: use24HourTime) { _, newValue in
                                timeViewModel.use24HourTime = newValue
                            }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    Divider()
                        .padding(.horizontal, 16)

                    // Time zone selection
                    HStack {
                        Text("Time zone")
                        Spacer()
                        Menu {
                            ForEach(PopularTimezones.all, id: \.identifier) { timezone in
                                Button {
                                    timeViewModel.updateTimezone(timezone.identifier)
                                } label: {
                                    let timeZone = TimeZone(identifier: timezone.identifier)!
                                    let offset = timeZone.secondsFromGMT() / 3600
                                    let offsetString = offset >= 0 ? "+\(offset)" : "\(offset)"
                                    Text("\(timezone.cityName) (UTC\(offsetString))")
                                }
                            }
                        } label: {
                            Text(selectedTimezoneDisplay)
                                .frame(maxWidth: 200)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    Divider()
                        .padding(.horizontal, 16)

                    // Prefix text, with no blue focus ring
                    HStack(alignment: .top) {
                        Text("Prefix text")
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            NoFocusRingTextField(placeholder: "Optional (e.g. 🇺🇸)", text: $prefixText)
                                .frame(width: 200)
                                .onChange(of: prefixText) { _, newValue in
                                    timeViewModel.prefixText = newValue
                                }

                            Text("Tip: Use a flag emoji")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
        }
        .padding(20)
        .frame(width: 400, height: 320)
        // make whole window use the same dark system group color
        .background(Color(NSColor.controlBackgroundColor))
        .onAppear {
            use24HourTime = timeViewModel.use24HourTime
            prefixText = timeViewModel.prefixText
        }
    }
}

/// An AppKit-backed text field that looks native but hides the blue focus ring.
struct NoFocusRingTextField: NSViewRepresentable {
    final class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: NoFocusRingTextField
        init(_ parent: NoFocusRingTextField) { self.parent = parent }

        func controlTextDidChange(_ obj: Notification) {
            guard let tf = obj.object as? NSTextField else { return }
            parent.text = tf.stringValue
        }
    }

    var placeholder: String
    @Binding var text: String

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeNSView(context: Context) -> NSTextField {
        let tf = NSTextField(string: text)
        tf.placeholderString = placeholder
        tf.isBezeled = true
        tf.bezelStyle = .roundedBezel
        tf.focusRingType = .none          // key line: no blue focus ring
        tf.drawsBackground = true         // keep default look
        tf.isEditable = true
        tf.isSelectable = true
        tf.delegate = context.coordinator
        return tf
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        if nsView.stringValue != text {
            nsView.stringValue = text
        }
    }
}
