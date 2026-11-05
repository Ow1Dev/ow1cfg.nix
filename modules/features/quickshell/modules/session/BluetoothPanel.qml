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
    property var devices: []
    property var resolvedNames: ({})
    function isAddress(name) { return /^([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}$/.test(name); }
    readonly property var namedDevices: devices.map(device => ({ address: device.address, name: resolvedNames[device.address] || device.name }))
                                              .filter(device => !isAddress(device.name))
                                              .sort((a, b) => Number(!!connected[b.address]) - Number(!!connected[a.address]) || a.name.localeCompare(b.name))
    property var paired: ({})
    property var connected: ({})
    property bool powered: false
    property bool firstScan: true
    property string message: "Loading Bluetooth…"
    property string target: ""

    function parseDevices(text) {
        const result = {};
        for (const line of text.split("\n")) {
            const match = /^Device ([0-9A-Fa-f:]{17}) (.+)$/.exec(line.trim());
            if (match) result[match[1]] = match[2];
        }
        return result;
    }
    function refresh() { adapter.running = true; pairedList.running = true; connectedList.running = true; allList.running = true; }
    function scan() {
        if (!powered || discovery.running) return;
        message = "Searching for devices (10 seconds)…";
        discovery.running = true;
    }
    Component.onCompleted: refresh()
    Process {
        id: adapter
        command: ["bluetoothctl", "show"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.powered = /\bPowered: yes\b/.test(text);
                if (!/\bController\b/.test(text)) root.message = "No Bluetooth adapter found.";
                else if (!root.powered) root.message = "Bluetooth is off.";
                if (root.firstScan && root.powered) { root.firstScan = false; root.scan(); }
            }
        }
    }
    Process {
        id: allList
        command: ["bluetoothctl", "devices"]
        stdout: StdioCollector {
            onStreamFinished: {
                const found = root.parseDevices(text);
                root.devices = Object.keys(found).map(address => ({ address: address, name: found[address] }));
                details.queue = root.devices.filter(device => !root.resolvedNames[device.address] && root.isAddress(device.name)).map(device => device.address);
                if (!details.running) details.next();
                if (!root.namedDevices.length && root.powered && !discovery.running) root.message = "No named devices found. Put your device in pairing mode and Scan.";
            }
        }
    }
    // Some controllers initially report an address as the device name. Ask BlueZ for
    // its advertised Name/Alias; never display a raw hardware address as a label.
    Process {
        id: details
        property var queue: []
        property string address: ""
        command: ["bluetoothctl", "info", address]
        function next() {
            if (!queue.length) return;
            address = queue.shift();
            running = true;
        }
        stdout: StdioCollector {
            onStreamFinished: {
                const name = text.split("\n").map(line => /^\s*(?:Name|Alias):\s*(.+)$/.exec(line))
                                 .filter(match => match !== null).map(match => match[1])
                                 .find(value => !root.isAddress(value));
                if (name) {
                    root.resolvedNames = Object.assign({}, root.resolvedNames, { [details.address]: name });
                    if (root.namedDevices.length) root.message = "";
                }
            }
        }
        onExited: next()
    }
    Process {
        id: pairedList
        command: ["bluetoothctl", "devices", "Paired"]
        stdout: StdioCollector { onStreamFinished: root.paired = root.parseDevices(text) }
    }
    Process {
        id: connectedList
        command: ["bluetoothctl", "devices", "Connected"]
        stdout: StdioCollector { onStreamFinished: root.connected = root.parseDevices(text) }
    }
    Process {
        id: discovery
        command: ["bluetoothctl", "--timeout", "10", "scan", "on"]
        onExited: { root.message = ""; root.refresh(); }
    }
    Process {
        id: action
        property string operation: ""
        property string errorText: ""
        stderr: StdioCollector { onStreamFinished: action.errorText = text.trim() }
        onExited: function(exitCode) {
            if (exitCode !== 0) {
                root.message = errorText || "Bluetooth operation failed. Try again.";
                root.refresh();
            } else if (operation === "pair") {
                root.message = "Pairing complete. Connecting…";
                operation = "connect";
                errorText = "";
                command = ["bluetoothctl", "connect", root.target];
                running = true;
            } else {
                root.message = operation === "connect" ? "Connected." : "Bluetooth updated.";
                root.refresh();
            }
        }
    }
    ColumnLayout {
        id: content
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: 10 }
        spacing: 7
        RowLayout {
            Layout.fillWidth: true
            Text { Layout.fillWidth: true; text: "Bluetooth"; color: Nord.fg; font { pixelSize: 11; bold: true } }
            ConnectivityButton {
                text: root.powered ? "Turn off" : "Turn on"
                enabled: action ? !action.running : false
                onClicked: {
                    action.operation = "power"; action.errorText = "";
                    action.command = ["bluetoothctl", "power", root.powered ? "off" : "on"];
                    action.running = true;
                }
            }
            ConnectivityButton { text: discovery && discovery.running ? "Scanning…" : "Scan"; enabled: root.powered && discovery && !discovery.running; onClicked: root.scan() }
        }
        Text { Layout.fillWidth: true; visible: root.message !== ""; text: root.message; wrapMode: Text.Wrap; color: Nord.secondary; font.pixelSize: 10 }
        Flickable {
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(10, root.namedDevices.length) * 34
            visible: root.powered && root.namedDevices.length > 0
            clip: true
            contentHeight: deviceRows.implicitHeight
            boundsBehavior: Flickable.StopAtBounds
            ColumnLayout {
                id: deviceRows
                width: parent.width - (parent.contentHeight > parent.height ? 8 : 0)
                spacing: 4
                Repeater {
                    model: root.namedDevices
                    ConnectivityButton {
                        required property var modelData
                        Layout.fillWidth: true
                        text: modelData.name + (root.connected[modelData.address] ? "  ·  Connected" : root.paired[modelData.address] ? "  ·  Paired" : "")
                        Accessible.name: (root.connected[modelData.address] ? "Disconnect " : "Connect ") + modelData.name
                        enabled: action ? !action.running : false
                        onClicked: {
                            root.target = modelData.address;
                            action.errorText = "";
                            action.operation = root.connected[modelData.address] ? "disconnect" : root.paired[modelData.address] ? "connect" : "pair";
                            action.command = ["bluetoothctl", action.operation, root.target];
                            root.message = action.operation === "pair" ? "Pairing with " + modelData.name + "…" : action.operation === "disconnect" ? "Disconnecting…" : "Connecting…";
                            action.running = true;
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
    }
}
