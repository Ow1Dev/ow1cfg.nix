import "../core"
import QtQuick

Segment {
    id: root
    signal activated()
    Text {
        text: ""
        font.pixelSize: 14
        color: hover.containsMouse ? Nord.accent : Nord.fg
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
