import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../core"
import "../Icons" as Icons

Button {
    id: root
    implicitHeight: 30
    padding: 6
    property bool locked: false
    background: Rectangle {
        radius: 7
        color: root.enabled && (root.down || root.hovered) ? Nord.accent : Nord.pillHover
        border.color: root.enabled && root.hovered ? Nord.accent : Nord.sep
        opacity: root.enabled ? 1 : 0.5
    }
    contentItem: RowLayout {
        spacing: 5
        Text {
            Layout.fillWidth: true
            text: root.text
            color: !root.enabled ? Nord.hint : root.down || root.hovered ? Nord.accentFg : Nord.text
            font.pixelSize: 10
            font.bold: root.down
            horizontalAlignment: root.locked ? Text.AlignLeft : Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        Icons.Icon {
            visible: root.locked
            name: "wifi-lock"
            color: root.down || root.hovered ? Nord.accentFg : Nord.fg
            implicitWidth: 15
            implicitHeight: 15
        }
    }
}
