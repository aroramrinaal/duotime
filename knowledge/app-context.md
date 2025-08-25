# duotime – ai agent knowledge doc

## overview

**duotime** is a lightweight macOS menu bar utility app. its purpose is simple: let the user see a **second clock** in their menu bar for a chosen time zone. this is especially useful for people working remotely across different time zones who want an always-visible reference without opening system settings or spotlight search.

* platform: macos
* language: swift
* ui framework: swiftui
* core api: `MenuBarExtra`

## app identity

* app name: **duotime**
* bundle id: `com.aroramrinaal.duotime`
* form factor: menu bar only (dockless)
* target macos: 13+

## key behaviors

1. display a live-updating clock in the menu bar for a user-selected timezone.
2. provide a dropdown menu with:

   * open settings
   * toggle 12/24h
   * toggle show seconds
   * launch at login
   * quit
3. settings window:

   * searchable timezone picker
   * format options
   * preview clock

## technical foundation

### MenuBarExtra usage

we use swiftui’s `MenuBarExtra` to define the app’s main scene. this renders a persistent control in the macos system menu bar.

**example skeleton:**

```swift
@main
struct DuotimeApp: App {
    var body: some Scene {
        MenuBarExtra {
            MenuContent()
        } label: {
            ClockLabel()
        }

        Settings {
            SettingsView()
        }
    }
}
```

### clock label

* `TimelineView` provides periodic updates (per second or per minute).
* formatted using `DateFormatter` or `Date.FormatStyle` with a fixed timezone.

```swift
TimelineView(.periodic(from: .now, by: 60)) { context in
    Text(timeString(date: context.date, tzID: tzID, showSeconds: false, use24h: true))
}
```

### LSUIElement

for dockless behavior, set this in `info.plist`:

```xml
<key>LSUIElement</key>
<true/>
```

this ensures duotime only appears in the menu bar.

### launch at login

* implemented with `SMAppService.mainApp.register()` and `.unregister()`
* toggle stored via `@AppStorage`

### data persistence

* use `@AppStorage` for simple user defaults:

  * selected timezone
  * show seconds (bool)
  * 12/24h (bool)

no need for Core Data or SwiftData.

## roadmap

* v1: single clock, settings, launch at login
* v1.1: allow multiple clocks side-by-side in the bar
* v2: add working-hours highlighting or color coding

## ai agent focus

when reasoning about duotime:

* prioritize `MenuBarExtra` as the primary scene
* remember LSUIElement must be set for true utility mode
* use `TimelineView` to keep the clock ticking smoothly
* keep menus lightweight and quick-access
* persistence is handled with `@AppStorage`, not databases

---

this document should serve as knowledge context for any ai agent tasked with assisting development, debugging, or extending duotime.


## App Icon(s) color theme
`#2c52d4`
`#8fb6fa`
`#a5cffc`
`#345cdb`
`#78adfc`
