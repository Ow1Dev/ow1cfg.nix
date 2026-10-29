import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "../core"
import "../Icons" as Icons

Rectangle {
    id: root
    required property string title
    required property string glyph
    required property PwNode node
    readonly property var audio: node ? node.audio : null
    implicitWidth: 126
    implicitHeight: 112
    radius: 11
    color: Nord.pill
    ColumnLayout {
        anchors { fill: parent; margins: 10 }
        spacing: 4
        RowLayout {
            spacing: 5
            Button {
                implicitWidth: 18; implicitHeight: 18
                enabled: root.audio !== null
                Accessible.name: (root.audio && root.audio.muted ? "Unmute " : "Mute ") + root.title
                onClicked: root.audio.muted = !root.audio.muted
                background: Rectangle { color: "transparent" }
                contentItem: Icons.Icon { name: root.glyph; color: root.audio && root.audio.muted ? Nord.batLow : Nord.accent }
            }
            Text { Layout.fillWidth: true; text: root.title; color: Nord.text; font.pixelSize: 9 }
        }
        Text { text: root.audio ? (root.audio.muted ? "Muted · " : "") + Math.round(root.audio.volume * 100) + "%" : "Unavailable"; color: Nord.secondary; font.pixelSize: 10 }
        Slider {
            Layout.fillWidth: true
            from: 0; to: 1; stepSize: 0.01
            enabled: root.audio !== null
            value: root.audio ? root.audio.volume : 0
            Accessible.name: root.title
            onMoved: if (root.audio) root.audio.volume = value
            background: Rectangle {
                x: parent.leftPadding; y: parent.topPadding + parent.availableHeight / 2 - height / 2
                implicitHeight: 4; width: parent.availableWidth; radius: 2; color: Nord.pillHover
                Rectangle { width: parent.width * parent.parent.visualPosition; height: parent.height; radius: 2; color: Nord.accent }
            }
            handle: Rectangle {
                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                implicitWidth: 10; implicitHeight: 10; radius: 5; color: Nord.accent
            }
        }
        Text { Layout.fillWidth: true; text: root.node ? (root.node.description || root.node.name) : "No device connected"; elide: Text.ElideRight; color: Nord.hint; font.pixelSize: 8 }
    }
}
