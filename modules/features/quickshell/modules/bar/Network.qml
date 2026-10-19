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
    Row {
        anchors.centerIn: parent
        spacing: 2
        Repeater {
            model: 4
            Rectangle {
                required property int index
                width: 3; height: 4 + index * 3; y: 13 - height; radius: 1
                color: root.connected && root.strength > index * 25 ? Nord.bat : Nord.pillHover
            }
        }
    }
}
