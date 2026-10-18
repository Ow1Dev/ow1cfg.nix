import QtQuick
import Quickshell
import Quickshell.Io

// .s.ws.cdot.pill — mango tags as dots; the active tag stretches into a pill.
// State comes from mango's IPC: `mmsg watch all-tags` streams one JSON object
// per line: {"all_tags":[{"monitor":"eDP-1","tags":[{"index":1,"is_active":...}]}]}
Segment {
    id: root

    property ShellScreen screen: null
    property var tags: []

    spacing: 7

    function viewTag(index) {
        dispatch.command = ["mmsg", "dispatch", `view,${index},0`];
        dispatch.running = true;
    }

    Process {
        id: dispatch
    }

    Process {
        id: watcher
        command: ["mmsg", "watch", "all-tags"]
        running: true

        stdout: SplitParser {
            onRead: data => {
                try {
                    const all = JSON.parse(data).all_tags ?? [];
                    let entry = all[0];
                    if (root.screen) {
                        const match = all.find(e => e.monitor === root.screen.name);
                        if (match)
                            entry = match;
                    }
                    root.tags = entry?.tags ?? [];
                } catch (err) {}
            }
        }

        // If mango restarts the stream dies — keep retrying.
        onExited: restartTimer.start()
    }

    Timer {
        id: restartTimer
        interval: 2000
        onTriggered: watcher.running = true
    }

    Repeater {
        model: root.tags

        delegate: Item {
            id: dot

            required property var modelData
            readonly property bool active: modelData.is_active === true

            implicitWidth: active ? 16 : 5
            implicitHeight: root.implicitHeight

            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }

            Rectangle {
                anchors.centerIn: parent
                width: dot.implicitWidth
                height: dot.active ? 6 : 5
                radius: height / 2
                color: dot.active ? Nord.accent : (hover.containsMouse ? Nord.fg : Nord.muted)

                Behavior on height {
                    NumberAnimation {
                        duration: 150
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }
            }

            MouseArea {
                id: hover
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.viewTag(dot.modelData.index)
            }
        }
    }
}
