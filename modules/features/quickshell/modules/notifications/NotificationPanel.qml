import "../core"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    property bool opened: false
    readonly property var popups: NotificationState.notifications.filter(n => NotificationState.popupIds.includes(n.id)).slice(-3).reverse()
    visible: opened || popups.length > 0
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "nord-notifications"
    WlrLayershell.keyboardFocus: opened ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    anchors { top: true; right: true }
    margins { top: 48; right: 20 }
    implicitWidth: Math.min(opened ? 340 : 320, screen ? screen.width - 40 : 340)
    implicitHeight: opened ? Math.min(center.implicitHeight, screen ? screen.height - 90 : 650) : toastStack.implicitHeight
    onOpenedChanged: { if (opened) { NotificationState.markRead(); center.forceActiveFocus(); } }
    Rectangle {
        id: center
        visible: root.opened
        anchors.fill: parent
        implicitHeight: content.implicitHeight + 30
        radius: 18; color: Nord.launcherBg
        border { width: 1; color: Nord.launcherBorder }
        focus: root.opened
        Keys.onEscapePressed: root.opened = false
        Flickable {
            anchors { fill: parent; margins: 15 }
            contentHeight: content.implicitHeight
            clip: true
            ColumnLayout {
                id: content
                width: parent.width
                spacing: 8
                RowLayout {
                    Layout.fillWidth: true
                    Text { Layout.fillWidth: true; text: "Notifications"; color: Nord.fg; font { pixelSize: 14; bold: true } }
                    Text { text: "Mark all read"; color: Nord.secondary; font.pixelSize: 10; MouseArea { anchors.fill: parent; onClicked: NotificationState.markRead() } }
                    Text { text: "×"; color: Nord.hint; font.pixelSize: 16; MouseArea { anchors.fill: parent; onClicked: root.opened = false } }
                }
                Text { text: Qt.formatDateTime(new Date(), "dddd") + " · Today"; color: Nord.accent; font { pixelSize: 10; letterSpacing: 0.8 } }
                Text { visible: NotificationState.notifications.length === 0; Layout.fillWidth: true; Layout.margins: 20; text: "You're all caught up"; horizontalAlignment: Text.AlignHCenter; color: Nord.hint; font.pixelSize: 11 }
                Repeater {
                    model: NotificationState.notifications.slice().reverse()
                    NotificationCard { required property var modelData; notification: modelData; Layout.fillWidth: true }
                }
                Text {
                    visible: NotificationState.notifications.length > 0
                    Layout.alignment: Qt.AlignHCenter
                    Layout.margins: 6
                    text: "Clear all notifications"; color: Nord.secondary; font.pixelSize: 10
                    MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: NotificationState.clear() }
                }
            }
        }
    }
    Column {
        id: toastStack
        visible: !root.opened
        width: parent.width
        spacing: 8
        Repeater {
            model: root.popups
            NotificationCard { required property var modelData; notification: modelData; toast: true; width: toastStack.width }
        }
    }
}
