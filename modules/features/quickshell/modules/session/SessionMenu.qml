import "../Icons" as Icons
import "../core"
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Services.Pipewire
import "../notifications"
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
    property bool sessionExpanded: false
    property string uptime: "…"
    property bool confirming: false
    property string pendingAction: ""
    readonly property string userName: Quickshell.env("USER") || "User"
    onVisibleChanged: { confirming = false; sessionExpanded = false; pendingAction = ""; if (visible) uptimeProcess.running = true; if (visible) keys.forceActiveFocus(); }
    function run(action) {
        root.visible = false;
        if (action === "Lock") Quickshell.execDetached(["nord-lock"]);
        else if (action === "Sleep") Quickshell.execDetached(["systemctl", "suspend"]);
        else if (action === "Log out") Quickshell.execDetached(["mmsg", "dispatch", "quit"]);
        else Quickshell.execDetached(["systemctl", action === "Restart" ? "reboot" : "poweroff"]);
    }
    PwObjectTracker { objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource].filter(node => node !== null) }
    Process {
        id: uptimeProcess
        command: ["cat", "/proc/uptime"]
        stdout: StdioCollector {
            onStreamFinished: {
                const minutes = Math.floor(parseFloat(text) / 60);
                root.uptime = Math.floor(minutes / 60) + "h " + (minutes % 60) + "m";
            }
        }
    }
    Timer { interval: 60000; running: root.visible; repeat: true; onTriggered: uptimeProcess.running = true }
    Item {
        id: keys
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: { if (root.confirming) root.confirming = false; else if (root.sessionExpanded) root.sessionExpanded = false; else root.visible = false; }
        MouseArea { anchors.fill: parent; onClicked: root.visible = false }
        Rectangle {
            id: menu
            x: Math.max(12, Math.min(parent.width - width - 12, root.anchorRight - width))
            y: Nord.barHeight
            width: 290
            height: menuContent.implicitHeight + 28
            radius: 12
            color: "#2e3440"
            border { width: 1; color: Nord.launcherBorder }
            MouseArea { anchors.fill: parent }
            ColumnLayout {
                id: menuContent
                anchors { left: parent.left; right: parent.right; top: parent.top; margins: 14 }
                spacing: 3
                Item {
                    Layout.fillWidth: true
                    implicitHeight: 32
                    Layout.bottomMargin: 12
                    Rectangle { anchors.left: parent.left; width: 3; height: 32; color: Nord.accent }
                    ColumnLayout {
                        anchors { left: parent.left; leftMargin: 12; right: sessionToggle.left; rightMargin: 9; verticalCenter: parent.verticalCenter }
                        spacing: 2
                        Text { text: root.userName; color: Nord.fg; font { pixelSize: 12; bold: true } }
                        Text { text: "Uptime · " + root.uptime; color: Nord.secondary; font.pixelSize: 9 }
                    }
                    Button {
                        id: sessionToggle
                        anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                        implicitWidth: 29; implicitHeight: 29
                        Accessible.name: "Session and power"
                        onClicked: root.sessionExpanded = !root.sessionExpanded
                        background: Rectangle { radius: 9; color: Nord.pill; border.color: Nord.sep }
                        contentItem: Icons.Icon { name: "power"; color: "#d9969e" }
                    }
                }
                Repeater {
                    model: root.sessionExpanded ? ["Log out", "Restart", "Shut down"] : []
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
                                color: entry.index === 2 ? "#28bf616a" : Nord.pillHover
                                Icons.Icon { anchors.centerIn: parent; width: 13; height: 13; name: ["logout", "restart", "power"][entry.index]; color: entry.index === 2 ? "#e3a1a7" : Nord.accent }
                            }
                            Text { Layout.fillWidth: true; text: entry.modelData; color: entry.index === 2 ? "#e3a1a7" : Nord.text; font { pixelSize: 10; bold: true } }
                        }
                        MouseArea {
                            id: hover
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.pendingAction = entry.modelData; root.confirming = true;
                            }
                        }
                    }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 9
                    spacing: 8
                    AudioTile { Layout.fillWidth: true; title: "Volume"; glyph: "volume"; node: Pipewire.defaultAudioSink }
                    AudioTile { Layout.fillWidth: true; title: "Microphone"; glyph: "microphone"; node: Pipewire.defaultAudioSource }
                }
                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 9
                    spacing: 6
                    Repeater {
                        model: ["Lock", "Sleep", "Focus"]
                        Button {
                            required property string modelData
                            Layout.fillWidth: true
                            implicitHeight: 32
                            text: modelData
                            Accessible.name: modelData === "Focus" ? "Focus: silence notification popups" : modelData
                            checkable: modelData === "Focus"
                            checked: modelData === "Focus" && NotificationState.focusMode
                            onClicked: {
                                if (modelData === "Focus") NotificationState.focusMode = !NotificationState.focusMode;
                                else root.run(modelData);
                            }
                            background: Rectangle { radius: 8; color: parent.checked ? Nord.accent : Nord.pill }
                            contentItem: Text { text: parent.text; color: parent.checked ? Nord.accentFg : Nord.text; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; font.pixelSize: 10 }
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
                color: "#2e3440"
                border { width: 1; color: Nord.launcherBorder }
                MouseArea { anchors.fill: parent }
                ColumnLayout {
                    anchors { fill: parent; margins: 18 }
                    spacing: 8
                    Icons.Icon { Layout.alignment: Qt.AlignHCenter; implicitWidth: 25; implicitHeight: 25; name: root.pendingAction === "Log out" ? "logout" : root.pendingAction === "Restart" ? "restart" : "power"; color: "#e3a1a7" }
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
