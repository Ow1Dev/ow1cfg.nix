import "modules/bar"
import QtQuick
import Quickshell

Scope {
    Variants {
         model: Quickshell.screens
         delegate: Bar {
             required property ShellScreen modelData
             screen: modelData
         }
    }
}
