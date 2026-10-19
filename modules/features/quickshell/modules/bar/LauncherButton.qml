import "../core"
import QtQuick

Segment {
    id: root
    signal activated()
    Text {
        text: ""
        color: hover.containsMouse ? Nord.accent : Nord.fg
        font.pixelSize: 14
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
