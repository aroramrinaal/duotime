Protocol WindowStyle
A specification for the appearance and interaction of a window.
```swift
protocol WindowStyle
```

Topics

Getting built-in window styles

static var automatic: DefaultWindowStyle
The default window style.
static var hiddenTitleBar: 
HiddenTitleBarWindowStyle

A window style which hides both the window’s title and the backing of the titlebar area, allowing more of the window’s content to show.
static var plain: PlainWindowStyle
The plain window style.

static var titleBar: TitleBarWindowStyle

A window style which displays the title bar section of the window.

static var volumetric: VolumetricWindowStyle

A window style that creates a 3D volumetric window.

Supporting types
struct DefaultWindowStyle
The default window style.
struct HiddenTitleBarWindowStyle
A window style which hides both the window’s title and the backing of the titlebar area, allowing more of the window’s content to show.
struct PlainWindowStyle
The plain window style.
struct TitleBarWindowStyle
A window style which displays the title bar section of the window.
struct VolumetricWindowStyle
A window style that creates a 3D volumetric window.
Relationships
Conforming Types
DefaultWindowStyle
HiddenTitleBarWindowStyle
PlainWindowStyle
TitleBarWindowStyle
VolumetricWindowStyle