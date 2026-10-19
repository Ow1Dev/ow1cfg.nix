import "modules/bar"
import "modules/session"
import "modules/notifications"
import "modules/launcher"
import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: shell

    function toggleOnMonitor(monitorName) {
        const target = screens.instances.find(instance => instance.modelData.name === monitorName);
        if (!target) {
            console.warn("No launcher screen matches Mango monitor:", monitorName);
            return;
        }
        const shouldOpen = !target.launcher.visible;
        for (const instance of screens.instances) instance.launcher.visible = false;
        target.launcher.visible = shouldOpen;
    }

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            // Query at keypress time, rather than relying on screen enumeration order.
            if (!pointerMonitor.running) pointerMonitor.running = true;
        }
    }

    Process {
        id: pointerMonitor
        command: ["mmsg", "get", "cursorpos"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    shell.toggleOnMonitor(JSON.parse(text).monitor);
                } catch (error) {
                    console.warn("Could not read Mango pointer monitor:", error);
                }
            }
        }
    }

    Variants {
        id: screens
        model: Quickshell.screens
        delegate: Scope {
            required property ShellScreen modelData
            property alias launcher: appLauncher

            Bar {
                id: bar
                screen: modelData
                unread: NotificationState.unread
                onLauncherRequested: { sessionMenu.visible = false; notifications.opened = false; shell.toggleOnMonitor(modelData.name); }
                onNotificationsRequested: { appLauncher.visible = false; sessionMenu.visible = false; notifications.opened = !notifications.opened; }
                onPowerRequested: { appLauncher.visible = false; notifications.opened = false; sessionMenu.visible = !sessionMenu.visible; }
            }
            SessionMenu { id: sessionMenu; screen: modelData; anchorRight: bar.capsuleRight - 3 }
            NotificationPanel { id: notifications; screen: modelData }
            AppLauncher {
                id: appLauncher
                screen: modelData
            }
        }
    }
}
