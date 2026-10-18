import QtQuick

// .mod.seg — 24px pill capsule holding the bar segments.
Rectangle {
    id: root

    default property alias content: row.data

    implicitWidth: row.implicitWidth
    implicitHeight: 24
    radius: implicitHeight / 2
    color: Nord.pill

    Row {
        id: row
        height: root.implicitHeight
    }
}
