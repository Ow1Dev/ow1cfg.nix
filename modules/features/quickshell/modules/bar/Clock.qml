import QtQuick

// .s.clock[data-fmt="day"] — "Sat 14:32", ticking every second.
Segment {
    Text {
        id: timeText
        text: Qt.formatDateTime(new Date(), "ddd HH:mm")
        color: Nord.fg
        font.pixelSize: 12
        font.weight: Font.DemiBold

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: timeText.text = Qt.formatDateTime(new Date(), "ddd HH:mm")
        }
    }
}
