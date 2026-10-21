import "../Icons" as Icons
import "../core"
import QtQuick
import Quickshell.Services.UPower

// SVG battery outline with live charge fill and charging indicator.
// Hidden entirely on machines without a laptop battery.
Segment {
    id: root

    readonly property var device: UPower.displayDevice
    readonly property int pct: Math.max(0, Math.min(100, Math.round(device.percentage * 100)))
    readonly property bool charging: device.state === UPowerDeviceState.Charging
    readonly property bool low: pct <= 20 && !charging
    readonly property color batColor: low ? Nord.batLow : Nord.bat

    visible: device.isLaptopBattery
    spacing: 7

    Item {
        implicitWidth: 24
        implicitHeight: 16
        Icons.Icon {
            renderScale: Nord.barScale
            anchors.fill: parent
            name: "battery"
            color: root.batColor
        }
        // Keep the fill proportional to the actual battery percentage.
        Rectangle {
            x: 3; y: 5.5
            width: 15 * root.pct / 100
            height: 5; radius: 1
            color: root.batColor
        }
        Icons.BoltIcon {
            visible: root.charging
            // Match the visible battery outline, including the path's inset.
            x: 4.25; y: 1.25
            width: 13.5; height: 13.5
            color: Nord.pill
            fillColor: Nord.fg
        }
    }

    // .pct
    Text {
        text: root.pct + "%"
        color: Nord.fg
        font.pixelSize: 11
        font.weight: Font.DemiBold
    }
}
