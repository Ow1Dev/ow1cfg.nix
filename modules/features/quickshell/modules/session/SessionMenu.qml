import "../core"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    visible: false
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.namespace: "nord-session"
    anchors { top: true; left: true; right: true; bottom: true }
    property real anchorRight: width / 2 + 190
    property bool confirming: false
    property string pendingAction: ""
    readonly property string userName: Quickshell.env("USER") || "User"
    onVisibleChanged: { confirming = false; pendingAction = ""; if (visible) keys.forceActiveFocus(); }
    function run(action) {
        root.visible = false;
        if (action === "Lock") Quickshell.execDetached(["swaylock", "-f", "-c", "2e3440"]);
        else if (action === "Log out") Quickshell.execDetached(["mmsg", "dispatch", "quit"]);
        else Quickshell.execDetached(["systemctl", action === "Restart" ? "reboot" : "poweroff"]);
    }
    Item {
        id: keys
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: { if (root.confirming) root.confirming = false; else root.visible = false; }
        MouseArea { anchors.fill: parent; onClicked: root.visible = false }
        Rectangle {
            id: menu
            x: Math.max(12, Math.min(parent.width - width - 12, root.anchorRight - width))
            y: 36
            width: 232
            height: menuContent.implicitHeight + 16
            radius: 14
            color: "#ad2e3440"
            border { width: 1; color: "#36d8dee9" }
            MouseArea { anchors.fill: parent }
            ColumnLayout {
                id: menuContent
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 8 }
                spacing: 3
                RowLayout {
                    Layout.fillWidth: true
                    Layout.margins: 6
                    spacing: 8
                    Rectangle {
                        width: 27; height: 27; radius: 9
                        gradient: Gradient { GradientStop { position: 0; color: Nord.accent } GradientStop { position: 1; color: "#5e81ac" } }
                        Text { anchors.centerIn: parent; text: root.userName.charAt(0).toUpperCase(); color: Nord.accentFg; font { pixelSize: 11; bold: true } }
                    }
                    Column {
                        Text { text: root.userName; color: Nord.fg; font { pixelSize: 10; bold: true } }
                        Text { text: "Personal session"; color: Nord.hint; font.pixelSize: 8 }
                    }
                }
                Rectangle { Layout.fillWidth: true; Layout.bottomMargin: 5; height: 1; color: Nord.sep }
                Repeater {
                    model: ["Lock", "Log out", "Restart", "Shut down"]
                    Rectangle {
                        id: entry
                        required property string modelData
                        required property int index
                        Layout.fillWidth: true
                        implicitHeight: 31
                        radius: 8
                        color: hover.containsMouse ? Nord.pillHover : "transparent"
                        RowLayout {
                            anchors { fill: parent; leftMargin: 7; rightMargin: 7 }
                            spacing: 8
                            Rectangle {
                                width: 20; height: 20; radius: 6
                                color: entry.index === 3 ? "#28bf616a" : Nord.pillHover
                                Text { anchors.centerIn: parent; text: ["⌑", "⇥", "↻", "⏻"][entry.index]; color: entry.index === 3 ? "#e3a1a7" : Nord.accent; font.pixelSize: 11 }
                            }
                            Text { Layout.fillWidth: true; text: entry.modelData; color: entry.index === 3 ? "#e3a1a7" : Nord.text; font { pixelSize: 10; bold: true } }
                            Text { text: entry.index === 3 ? "›" : ""; color: Nord.hint; font.pixelSize: 12 }
                        }
                        MouseArea {
                            id: hover
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (entry.index === 0) root.run(entry.modelData);
                                else { root.pendingAction = entry.modelData; root.confirming = true; }
                            }
                        }
                    }
                }
            }
        }
        Rectangle {
            visible: root.confirming
            anchors.fill: parent
            color: "#88171b22"
            MouseArea { anchors.fill: parent; onClicked: root.confirming = false }
            Rectangle {
                anchors.centerIn: parent
                width: 300; height: 174; radius: 16
                color: Nord.launcherBg
                border { width: 1; color: Nord.launcherBorder }
                MouseArea { anchors.fill: parent }
                ColumnLayout {
                    anchors { fill: parent; margins: 18 }
                    spacing: 8
                    Text { Layout.alignment: Qt.AlignHCenter; text: "⏻"; color: "#e3a1a7"; font.pixelSize: 25 }
                    Text { Layout.alignment: Qt.AlignHCenter; text: root.pendingAction + "?"; color: Nord.fg; font { pixelSize: 13; bold: true } }
                    Text { Layout.fillWidth: true; text: "Unsaved work may be lost."; horizontalAlignment: Text.AlignHCenter; color: Nord.secondary; font.pixelSize: 10 }
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 6
                        Repeater {
                            model: ["Cancel", root.pendingAction]
                            Rectangle {
                                required property string modelData
                                required property int index
                                implicitWidth: label.implicitWidth + 18; implicitHeight: 27; radius: 7
                                color: index === 1 ? Nord.batLow : Nord.pill
                                Text { id: label; anchors.centerIn: parent; text: modelData; color: Nord.fg; font.pixelSize: 10 }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: { if (parent.index === 0) root.confirming = false; else root.run(root.pendingAction); } }
                            }
                        }
                    }
                }
            }
        }
    }
}
