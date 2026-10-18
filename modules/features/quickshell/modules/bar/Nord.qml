pragma Singleton
import QtQuick

// Nord palette, matching bar-inspiration.html concept 13
QtObject {
    readonly property color barBg: "#eb2e3440" // nord0 @ 92% (bar, blurred)
    readonly property color pill: "#3b4252" // nord1 (capsule)
    readonly property color pillHover: "#434c5e" // nord2
    readonly property color fg: "#eceff4" // nord6
    readonly property color muted: "#73d8dee9" // nord4 @ 45% (inactive dots)
    readonly property color sep: "#1feceff4" // nord6 @ 12% (segment dividers)
    readonly property color accent: "#88c0d0" // nord8 (active pill dot)
    readonly property color accentFg: "#2e3440" // nord0
    readonly property color bat: "#a3be8c" // nord14 (battery ok)
    readonly property color batLow: "#bf616a" // nord11 (battery low)
}
