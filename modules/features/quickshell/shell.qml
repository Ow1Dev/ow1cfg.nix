import "modules/bar"
import QtQuick
import Quickshell

Scope {
    Bar {}

    // Multi-monitor variant (needs Workspaces to match screen → monitor):
    // Variants {
    //     model: Quickshell.screens
    //     delegate: Bar {
    //         required property ShellScreen modelData
    //         screen: modelData
    //     }
    // }
}
