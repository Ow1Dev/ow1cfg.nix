import "../Icons" as Icons
import "../core"
import QtQuick
import Quickshell.Io

Item {
    id: root
    implicitWidth: 33
    implicitHeight: 24
    property int strength: 0
    property bool connected: false
    Process {
        id: status
        command: ["nmcli", "-t", "-f", "STATE", "general"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.connected = text.trim() === "connected" }
    }
    Process {
        id: wifi
        command: ["nmcli", "-t", "-f", "IN-USE,SIGNAL", "device", "wifi", "list", "--rescan", "no"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const active = text.split("\n").find(line => line.startsWith("*:"));
                root.strength = active ? Number(active.split(":")[1]) : (root.connected ? 100 : 0);
            }
        }
    }
    Timer { interval: 10000; running: true; repeat: true; onTriggered: { status.running = true; wifi.running = true; } }
    Icons.NetworkBars {
        renderScale: Nord.barScale
        anchors.centerIn: parent
        strength: root.connected ? Math.max(1, Math.min(4, Math.ceil(root.strength / 25))) : 0
        inactiveColor: Nord.pillHover
        color: root.connected ? Nord.bat : Nord.hint
    }
}
