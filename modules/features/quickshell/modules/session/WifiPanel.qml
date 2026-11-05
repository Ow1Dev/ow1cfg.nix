import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import "../core"

Rectangle {
    id: root
    implicitHeight: content.implicitHeight + 20
    radius: 11
    color: Nord.pill
    property var networks: []
    property bool wifiEnabled: false
    property string message: "Loading Wi-Fi…"
    property bool loading: true
    property bool busy: false
    property string selectedSsid: ""

    // nmcli escapes colons and backslashes in terse output (SSID may contain either).
    function fields(line) {
        let result = [], value = "", escaped = false;
        for (const char of line) {
            if (escaped) { value += char; escaped = false; }
            else if (char === "\\") escaped = true;
            else if (char === ":") { result.push(value); value = ""; }
            else value += char;
        }
        result.push(value);
        return result;
    }
    function refresh() { loading = true; radio.running = true; list.running = true; }
    Component.onCompleted: refresh()

    Process {
        id: radio
        command: ["nmcli", "-t", "-f", "WIFI", "radio"]
        stdout: StdioCollector { onStreamFinished: root.wifiEnabled = text.trim() === "enabled" }
    }
    Process {
        id: list
        command: ["nmcli", "-t", "-f", "IN-USE,SSID,SECURITY,SIGNAL", "device", "wifi", "list", "--rescan", "yes"]
        stdout: StdioCollector {
            onStreamFinished: {
                const seen = {}, entries = [];
                for (const line of text.split("\n")) {
                    const parts = root.fields(line);
                    if (parts.length < 4 || !parts[1]) continue;
                    const key = parts[1] + "\u0000" + parts[2];
                    if (!seen[key] || parts[0] === "*" || Number(parts[3]) > seen[key].signal) {
                        seen[key] = { ssid: parts[1], security: parts[2], signal: Number(parts[3]), active: parts[0] === "*" };
                    }
                }
                for (const key of Object.keys(seen)) entries.push(seen[key]);
                entries.sort((a, b) => Number(b.active) - Number(a.active) || b.signal - a.signal);
                root.networks = entries;
                if (!root.busy && (root.message === "Loading Wi-Fi…" || root.message === "Searching for Wi-Fi…")) root.message = entries.length ? "" : "No networks found. Try Refresh.";
            }
        }
        onExited: function(exitCode) {
            root.loading = false;
            if (exitCode !== 0 && root.wifiEnabled && !root.busy) root.message = "Could not scan Wi-Fi networks.";
        }
    }
    Process {
        id: action
        property string operation: ""
        property string errorText: ""
        stderr: StdioCollector { onStreamFinished: action.errorText = text.trim() }
        onExited: function(exitCode) {
            root.busy = false;
            root.message = exitCode === 0 ? (operation === "connect" ? "Connected." : "Wi-Fi updated.") : (errorText || "Wi-Fi operation failed.");
            root.selectedSsid = "";
            password.text = "";
            root.refresh();
        }
    }
    ColumnLayout {
        id: content
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 10 }
        spacing: 7
        RowLayout {
            Layout.fillWidth: true
            Text { Layout.fillWidth: true; text: "Wi-Fi"; color: Nord.fg; font { pixelSize: 11; bold: true } }
            ConnectivityButton { text: root.wifiEnabled ? "Turn off" : "Turn on"; onClicked: { action.operation = "radio"; action.errorText = ""; action.command = ["nmcli", "radio", "wifi", root.wifiEnabled ? "off" : "on"]; action.running = true; } }
            ConnectivityButton { text: "Refresh"; enabled: list ? !list.running : false; onClicked: { root.message = "Searching for Wi-Fi…"; root.refresh(); } }
        }
        ConnectivitySpinner {
            Layout.alignment: Qt.AlignHCenter
            visible: root.loading || root.busy
        }
        Text { Layout.fillWidth: true; visible: root.message !== ""; text: root.message; wrapMode: Text.Wrap; horizontalAlignment: Text.AlignHCenter; color: Nord.secondary; font.pixelSize: 10 }
        Flickable {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(10, root.networks.length) * 34
            visible: root.wifiEnabled && root.networks.length > 0
            clip: true
            contentHeight: networkRows.implicitHeight
            boundsBehavior: Flickable.StopAtBounds
            ColumnLayout {
                id: networkRows
                width: parent.width - (parent.contentHeight > parent.height ? 8 : 0)
                spacing: 4
                Repeater {
                    model: root.networks
                    ConnectivityButton {
                        required property var modelData
                        Layout.fillWidth: true
                        text: modelData.ssid + (modelData.active ? "  ✓" : "") + "  ·  " + modelData.signal + "%"
                        locked: modelData.security !== "--"
                        Accessible.name: (modelData.active ? "Connected to " : "Connect to ") + modelData.ssid
                        onClicked: {
                            if (modelData.active) return;
                            if (modelData.security !== "--") { root.selectedSsid = modelData.ssid; password.text = ""; password.forceActiveFocus(); }
                            else root.connect(modelData.ssid, "");
                        }
                    }
                }
            }
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                background: Rectangle { color: "transparent" }
                contentItem: Rectangle { radius: 3; color: Nord.accent; opacity: 0.7 }
            }
        }
        TextField {
            id: password
            Layout.fillWidth: true
            visible: root.selectedSsid !== ""
            placeholderText: "Password for " + root.selectedSsid
            color: Nord.fg
            placeholderTextColor: Nord.hint
            font.pixelSize: 10
            background: Rectangle { radius: 7; color: Nord.pillHover; border.color: Nord.sep }
            echoMode: TextInput.Password
            onAccepted: root.connect(root.selectedSsid, text)
        }
        ConnectivityButton {
            visible: root.selectedSsid !== ""
            text: "Connect"; enabled: action ? !action.running : false
            onClicked: root.connect(root.selectedSsid, password.text)
        }
    }
    function connect(ssid, secret) {
        if (action.running || !ssid) return;
        action.operation = "connect";
        action.errorText = "";
        action.command = ["nmcli", "device", "wifi", "connect", ssid];
        if (secret) action.command = action.command.concat(["password", secret]);
        message = "Connecting to " + ssid + "…";
        busy = true;
        action.running = true;
    }
}
