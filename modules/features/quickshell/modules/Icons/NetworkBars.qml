pragma ComponentBehavior: Bound
import QtQuick

// Direct geometry avoids rasterizing and scaling the small signal lines.
Item {
    id: root
    property int strength: 0 // 0–4 illuminated bars
    property color color: "white"
    property color inactiveColor: "#4c566a"
    property real renderScale: 1
    readonly property real pixelScale: Math.max(0.1, renderScale * Screen.devicePixelRatio)
    readonly property real lineWidth: Math.max(1, Math.round(2 * pixelScale)) / pixelScale
    readonly property real gap: Math.max(1, Math.round(1.5 * pixelScale)) / pixelScale
    implicitWidth: lineWidth * 4 + gap * 3
    implicitHeight: Math.round(13 * pixelScale) / pixelScale

    Repeater {
        model: 4
        Rectangle {
            required property int index
            x: index * (root.lineWidth + root.gap)
            y: root.height - height
            width: root.lineWidth
            height: Math.round((4 + index * 3) * root.pixelScale) / root.pixelScale
            color: index < root.strength ? root.color : root.inactiveColor
            antialiasing: false
        }
    }
}
