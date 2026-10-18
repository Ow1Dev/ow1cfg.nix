import QtQuick
import Quickshell

// .s.launcher — ❄ snowflake, clickable.
// Point `command` at an app launcher (rofi/vicinae/...) if you add one.
Segment {
    id: root

    property string glyph: "❄"
    property var command: ["foot"]

    Text {
        text: root.glyph
        color: Nord.fg
        font.pixelSize: 13

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Quickshell.execDetached(root.command)
        }
    }
}
