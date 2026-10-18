import "../core"
import QtQuick
import Quickshell

// Concept 13 "Dots · Pill Active": 35px blurred nord0 bar with a single
// centered capsule holding launcher | workspaces | clock | battery.
PanelWindow {
    id: root
    signal launcherRequested()

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 35
    color: Nord.barBg

    // .bar.nd-a — rgba(46,52,64,.92) (blur comes from mango's blur_layer=1)

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: Nord.barBorder
    }

    Capsule {
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
        Battery {
            divider: true
        }
    }
}
