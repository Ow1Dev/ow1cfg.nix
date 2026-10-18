import "../core"
import QtQuick
import Quickshell.Services.UPower

// .s.bat — css-drawn battery shell + nub, ⚡ when charging, red when low.
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

    // .bolt
    Text {
        visible: root.charging
        text: "⚡"
        color: Nord.fg
        font.pixelSize: 10
    }

    // .bshell + ::after nub
    Item {
        implicitWidth: 24
        implicitHeight: 10

        Rectangle {
            width: 20
            height: 10
            radius: 3.5
            color: "transparent"
            border.width: 1.5
            border.color: root.batColor

            // .bfill
            Rectangle {
                x: 1.5
                y: 1.5
                height: 7
                width: 17 * root.pct / 100
                radius: 1.5
                color: root.batColor
            }
        }

        Rectangle {
            x: 21.5
            y: 3
            width: 2
            height: 4
            radius: 1
            color: root.batColor
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
