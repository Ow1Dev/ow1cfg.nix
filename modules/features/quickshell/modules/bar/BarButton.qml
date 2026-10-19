import "../core"
import QtQuick

Segment {
    id: root
    property string glyph: "bell"
    property bool unread: false
    signal activated()
    horizontalPadding: glyph === "power" ? 10 : 8
    Item {
        implicitWidth: 14
        implicitHeight: 16
        Canvas {
            id: drawing
            anchors.fill: parent
            property color ink: hover.containsMouse ? Nord.accent : Nord.text
            onInkChanged: requestPaint()
            onPaint: {
                const c = getContext("2d");
                c.reset(); c.strokeStyle = ink; c.lineWidth = 1.6;
                c.lineCap = "round"; c.lineJoin = "round";
                c.beginPath();
                if (root.glyph === "power") {
                    c.moveTo(7, 1); c.lineTo(7, 7);
                    // An open ring, drawn explicitly to avoid Canvas arc wrapping.
                    c.moveTo(3.1, 3.8);
                    c.bezierCurveTo(1.9, 4.9, 1.2, 6.4, 1.2, 8);
                    c.bezierCurveTo(1.2, 11.2, 3.8, 13.8, 7, 13.8);
                    c.bezierCurveTo(10.2, 13.8, 12.8, 11.2, 12.8, 8);
                    c.bezierCurveTo(12.8, 6.4, 12.1, 4.9, 10.9, 3.8);
                } else {
                    c.moveTo(2.5, 6); c.bezierCurveTo(2.5, 0, 11.5, 0, 11.5, 6);
                    c.bezierCurveTo(11.5, 11, 13, 11, 13, 12);
                    c.lineTo(1, 12); c.bezierCurveTo(1, 11, 2.5, 11, 2.5, 6);
                    c.moveTo(5.5, 15); c.lineTo(8.5, 15);
                }
                c.stroke();
            }
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
