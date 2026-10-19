import "../core"
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications

Rectangle {
    id: root
    required property var notification
    property bool toast: false
    readonly property bool critical: notification.urgency === NotificationUrgency.Critical
    implicitHeight: content.implicitHeight + 20
    radius: toast ? 14 : 11
    color: toast ? Nord.launcherBg : Nord.pill
    border { width: 1; color: root.critical ? "#88bf616a" : "#1cd8dee9" }
    ColumnLayout {
        id: content
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 10 }
        spacing: 6
        RowLayout {
            Layout.fillWidth: true
            spacing: 9
            Rectangle {
                width: 29; height: 29; radius: 9
                color: root.critical ? Nord.batLow : Nord.accent
                Text { anchors.centerIn: parent; text: root.critical ? "!" : root.notification.appName.charAt(0).toUpperCase(); color: Nord.accentFg; font { pixelSize: 13; bold: true } }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text { Layout.fillWidth: true; text: root.notification.appName || "Notification"; textFormat: Text.PlainText; elide: Text.ElideRight; color: Nord.hint; font.pixelSize: 9 }
                Text { Layout.fillWidth: true; text: root.notification.summary; textFormat: Text.PlainText; wrapMode: Text.Wrap; color: Nord.fg; font { pixelSize: 11; bold: true } }
            }
            Text {
                text: "×"; color: Nord.hint; font.pixelSize: 16
                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.notification.dismiss() }
            }
        }
        Text { visible: text.length > 0; Layout.fillWidth: true; text: root.notification.body; textFormat: Text.PlainText; wrapMode: Text.Wrap; maximumLineCount: root.toast ? 3 : 12; elide: Text.ElideRight; color: Nord.secondary; font.pixelSize: 10 }
        Flow {
            Layout.fillWidth: true
            spacing: 6
            Repeater {
                model: root.notification.actions
                Rectangle {
                    required property var modelData
                    required property int index
                    width: actionLabel.implicitWidth + 16; height: 24; radius: 6
                    color: index === 0 ? Nord.accent : Nord.pillHover
                    Text { id: actionLabel; anchors.centerIn: parent; text: parent.modelData.text; color: parent.index === 0 ? Nord.accentFg : Nord.text; font.pixelSize: 10 }
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: parent.modelData.invoke() }
                }
            }
        }
    }
}
