import "modules/bar"
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
                screen: modelData
                onLauncherRequested: shell.toggleOnMonitor(modelData.name)
            }
            AppLauncher {
                id: appLauncher
                screen: modelData
            }
        }
    }
}
