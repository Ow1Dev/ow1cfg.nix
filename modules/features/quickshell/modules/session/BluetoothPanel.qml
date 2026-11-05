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
    property bool loading: true
    property bool busy: false
    property string pendingVerify: ""
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
    function operate(operation, address, name) {
        if (!action) return;
        if (action.running) {
            message = "Still working on " + action.deviceName + "…";
            return;
        }
        // A status check must not leave Connect unusable if it returns no result.
        pendingVerify = "";
        target = address;
        action.deviceName = name;
        busy = true;
        action.operation = operation === "connect" && !paired[address] ? "pairable" : operation;
        action.startStage();
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
                if (!root.powered) root.loading = false;
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
                if (!root.namedDevices.length && root.powered && !discovery.running && !root.busy) root.message = "No named devices found. Put your device in pairing mode and Scan.";
                if (!discovery.running) root.loading = false;
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
                    if (root.namedDevices.length && !root.busy && !discovery.running) root.message = "";
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
        onExited: {
            if (root.pendingVerify) {
                root.message = root.connected[root.pendingVerify] ? "Connected to " + action.deviceName + "." : "Connection was not established. Keep the device in pairing mode and try Connect again.";
                root.pendingVerify = "";
                root.busy = false;
            }
        }
    }
    Process {
        id: discovery
        command: ["bluetoothctl", "--timeout", "10", "scan", "on"]
        onExited: {
            if (!root.busy) root.message = "";
            root.refresh();
        }
    }
    Process {
        id: action
        property string operation: ""
        property string deviceName: ""
        property string errorText: ""
        property string outputText: ""
        function startStage() {
            errorText = "";
            outputText = "";
            if (operation === "pairable") {
                root.message = "Preparing to pair with " + deviceName + "…";
                command = ["bluetoothctl", "pairable", "on"];
            } else if (operation === "pair") {
                root.message = "Pairing with " + deviceName + "… Keep it in pairing mode.";
                // A temporary local agent handles the usual headset 'Just Works' pairing.
                command = ["bluetoothctl", "--agent", "NoInputNoOutput", "--timeout", "30", "pair", root.target];
            } else if (operation === "connect" || operation === "disconnect") {
                root.message = (operation === "connect" ? "Connecting to " : "Disconnecting ") + deviceName + "…";
                command = ["bluetoothctl", "--timeout", "30", operation, root.target];
            } else if (operation === "power") {
                command = ["bluetoothctl", "power", root.powered ? "off" : "on"];
            }
            running = true;
        }
        stdout: StdioCollector { onStreamFinished: action.outputText = text.trim() }
        stderr: StdioCollector { onStreamFinished: action.errorText = text.trim() }
        onExited: function(exitCode) {
            const failure = (outputText + "\n" + errorText).split("\n").find(line => /failed|error/i.test(line));
            if (exitCode !== 0 || failure) {
                root.busy = false;
                root.message = (failure || errorText || "Bluetooth operation failed.") + " Keep the device in pairing mode and try again.";
                root.refresh();
            } else if (operation === "pairable" || operation === "pair") {
                operation = operation === "pairable" ? "pair" : "connect";
                startStage();
            } else {
                if (operation === "connect") {
                    root.pendingVerify = root.target;
                    root.message = "Checking connection to " + deviceName + "…";
                } else {
                    root.busy = false;
                    root.message = operation === "disconnect" ? "Disconnected." : "Bluetooth updated.";
                }
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
                onClicked: root.operate("power", "", "")
            }
            ConnectivityButton { text: discovery && discovery.running ? "Scanning…" : "Scan"; enabled: root.powered && discovery && !discovery.running; onClicked: root.scan() }
        }
        ConnectivitySpinner {
            Layout.alignment: Qt.AlignHCenter
            visible: root.loading || root.busy || (discovery && discovery.running)
        }
        Text { Layout.fillWidth: true; visible: root.message !== ""; text: root.message; wrapMode: Text.Wrap; horizontalAlignment: Text.AlignHCenter; color: Nord.secondary; font.pixelSize: 10 }
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
                    RowLayout {
                        id: deviceRow
                        required property var modelData
                        Layout.fillWidth: true
                        spacing: 5
                        Text {
                            Layout.fillWidth: true
                            text: deviceRow.modelData.name
                            color: Nord.text
                            font.pixelSize: 10
                            elide: Text.ElideRight
                        }
                        Text {
                            visible: !!root.connected[deviceRow.modelData.address]
                            text: "✓"
                            color: Nord.bat
                            font { pixelSize: 13; bold: true }
                            Accessible.name: "Connected"
                        }
                        ConnectivityButton {
                            Layout.preferredWidth: 85
                            text: root.busy && root.target === deviceRow.modelData.address ? "Working…" : root.connected[deviceRow.modelData.address] ? "Disconnect" : "Connect"
                            Accessible.name: text + " " + deviceRow.modelData.name
                            enabled: root.powered
                            onClicked: root.operate(root.connected[deviceRow.modelData.address] ? "disconnect" : "connect", deviceRow.modelData.address, deviceRow.modelData.name)
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
