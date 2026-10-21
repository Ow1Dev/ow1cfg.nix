import QtQuick
import QtQuick.Effects

// SVGs use white strokes; tint them here so callers can keep live theme/hover colors.
Item {
    id: root
    required property string name
    property color color: "white"
    // Account for an ancestor transform when rasterizing and tinting the SVG.
    property real renderScale: 1
    implicitWidth: 16
    implicitHeight: 16

    Image {
        id: artwork
        anchors.fill: parent
        source: Qt.resolvedUrl(root.name + ".svg")
        sourceSize.width: Math.ceil(width * root.renderScale * Screen.devicePixelRatio)
        sourceSize.height: Math.ceil(height * root.renderScale * Screen.devicePixelRatio)
        fillMode: Image.PreserveAspectFit
        layer.enabled: true
        layer.textureSize: Qt.size(sourceSize.width, sourceSize.height)
        visible: false
    }
    MultiEffect {
        anchors.fill: artwork
        source: artwork
        colorization: 1
        colorizationColor: root.color
    }
}
