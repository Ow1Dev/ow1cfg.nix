import "../core"
import QtQuick
import Quickshell

// Scale the capsule, typography and pointer targets together.
PanelWindow {
    id: root
    signal launcherRequested()
    signal notificationsRequested()
    signal powerRequested()
    property bool unread: false
    readonly property real capsuleRight: capsule.x + capsule.width * (1 + capsule.scale) / 2

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Nord.barHeight
    color: "transparent"

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: "transparent"
    }

    Capsule {
        id: capsule
        scale: Nord.barScale
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        LauncherButton { onActivated: root.launcherRequested() }
        Workspaces {
            divider: true
            screen: root.screen
        }
        Clock {
            divider: true
        }
        Segment {
            divider: true
            horizontalPadding: 8
            spacing: 6
            Network {}
            BarButton {
                glyph: "bell"
                horizontalPadding: 0
                unread: root.unread
                onActivated: root.notificationsRequested()
            }
            Battery { horizontalPadding: 0 }
        }
        BarButton {
            divider: true
            glyph: "profile"
            onActivated: root.powerRequested()
        }
    }
}
