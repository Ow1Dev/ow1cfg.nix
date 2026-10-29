import "../Icons" as Icons
import "../core"
import QtQuick

Segment {
    id: root
    property string glyph: "bell"
    property bool unread: false
    signal activated()
    horizontalPadding: glyph === "profile" ? 10 : 8
    Item {
        implicitWidth: 14
        implicitHeight: 16
        Icons.Icon {
            visible: root.glyph !== "bell"
            renderScale: Nord.barScale
            anchors.centerIn: parent
            width: 16; height: 16
            name: root.glyph
            color: hover.containsMouse || root.glyph === "profile" ? Nord.accent : Nord.text
        }
        Icons.BellIcon {
            visible: root.glyph === "bell"
            anchors.centerIn: parent
            width: 16; height: 16
            color: hover.containsMouse || root.glyph === "profile" ? Nord.accent : Nord.text
        }
        Rectangle { visible: root.unread; width: 5; height: 5; radius: 3; x: 9; y: 0; color: Nord.batLow }
    }
    MouseArea {
        id: hover
        parent: root
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.activated()
    }
}
