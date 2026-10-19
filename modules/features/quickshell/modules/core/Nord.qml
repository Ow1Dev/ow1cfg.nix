pragma Singleton
import QtQuick

// Nord palette, matching nord-desktop-bar.html
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
    readonly property color barBorder: "#0ceceff4"
    readonly property color capsuleBorder: "#08ffffff"
    readonly property color launcherBg: "#f72e3440"
    readonly property color launcherBorder: "#4c566a"
    readonly property color compactBorder: "#12ffffff"
    readonly property color secondary: "#b8c2ce"
    readonly property color hint: "#8995a7"
    readonly property color placeholder: "#8ac4cedb"
    readonly property color text: "#d8dee9"
    readonly property color metadata: "#748195"
    readonly property color selectedMetadata: "#b32e3440"
    readonly property var iconTop: ["#88c0d0", "#ebcb8b", "#e5e9f0", "#b48ead", "#d08770", "#a3be8c"]
    readonly property var iconBottom: ["#5e81ac", "#d08770", "#8c9bad", "#806687", "#bf616a", "#719365"]
}

