// duotimeApp.swift
import SwiftUI
import AppKit

struct MenuBarContent: View {
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Button("Change Timezone") {
            openWindow(id: "settings")
        }
        .keyboardShortcut(",", modifiers: .command)

        Divider()

        Button("Quit duotime") {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q", modifiers: .command)
    }
}

@main
struct duotimeApp: App {
    @StateObject private var timeViewModel = TimeViewModel()

    var body: some Scene {
        // menu bar
        MenuBarExtra {
            MenuBarContent()
        } label: {
            Text(timeViewModel.currentTime)
                .font(.system(.body, design: .monospaced))
        }

        // settings window
        Window("Settings", id: "settings") {
            SettingsView(timeViewModel: timeViewModel)
                .onAppear {
                    becomeRegularWithMinimalMenu()
                    NSApp.activate(ignoringOtherApps: true)
                }
                .onDisappear {
                    NSApp.setActivationPolicy(.accessory)
                    NSApp.mainMenu = nil
                }
        }
        .windowResizability(.contentSize)
        .windowStyle(.titleBar)
        .defaultSize(width: 400, height: 300)
    }
}

// MARK: - minimal app menu with only "About duotime"

private func becomeRegularWithMinimalMenu() {
    NSApp.setActivationPolicy(.regular)

    let appName =
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ??
        "Duotime"

    let mainMenu = NSMenu()
    let appMenuItem = NSMenuItem()
    mainMenu.addItem(appMenuItem)

    let appMenu = NSMenu(title: appName)
    appMenuItem.submenu = appMenu

    let about = NSMenuItem(
        title: "About \(appName)",
        action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
        keyEquivalent: ""
    )
    about.target = NSApp
    appMenu.addItem(about)

    NSApp.mainMenu = mainMenu
}
