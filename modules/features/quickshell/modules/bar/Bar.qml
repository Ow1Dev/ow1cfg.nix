import QtQuick
import Quickshell

// Concept 13 "Dots · Pill Active": 35px blurred nord0 bar with a single
// centered capsule holding launcher | workspaces | clock | battery.
PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 35
    color: "transparent"

    // .bar.nd-a — rgba(46,52,64,.92) (blur comes from mango's blur_layer=1)
    Rectangle {
        anchors.fill: parent
        color: Nord.barBg
    }

    Capsule {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Launcher {}
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
