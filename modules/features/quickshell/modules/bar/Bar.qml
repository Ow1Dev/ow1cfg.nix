import "../core"
import QtQuick
import Quickshell

// Scale the reference capsule by 1.5, including typography and pointer targets.
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

    implicitHeight: 53
    color: "transparent"

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: "transparent"
    }

    Capsule {
        id: capsule
        scale: 1.5
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
            horizontalPadding: 5
            spacing: 0
            Network {}
            BarButton {
                glyph: "bell"
                unread: root.unread
                onActivated: root.notificationsRequested()
            }
            Battery { horizontalPadding: 8 }
        }
        BarButton {
            divider: true
            glyph: "power"
            onActivated: root.powerRequested()
        }
    }
}
