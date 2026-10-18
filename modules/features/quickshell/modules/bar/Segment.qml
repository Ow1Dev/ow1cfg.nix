import QtQuick
import QtQuick.Layouts

// .seg > .s — one capsule segment: optional left divider + 12px side padding.
Item {
    id: root

    property bool divider: false
    property alias spacing: container.spacing
    default property alias content: container.data

    implicitWidth: sep.width + container.implicitWidth + 24
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
        x: sep.width + 12
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6
    }
}
