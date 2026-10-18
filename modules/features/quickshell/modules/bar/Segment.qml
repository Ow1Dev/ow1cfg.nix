import "../core"
import QtQuick
import QtQuick.Layouts

// .seg > .s — one capsule segment: optional left divider + 11px side padding.
Item {
    id: root

    property bool divider: false
    property int horizontalPadding: 11
    property alias spacing: container.spacing
    default property alias content: container.data

    implicitWidth: sep.width + container.implicitWidth + horizontalPadding * 2
    implicitHeight: 24

    Rectangle {
        id: sep
        visible: root.divider
        width: root.divider ? 1 : 0
        height: root.implicitHeight
        color: Nord.sep
    }

    RowLayout {
        id: container
        x: sep.width + root.horizontalPadding
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6
    }
}
