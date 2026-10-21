import QtQuick
import QtQuick.Shapes

// Render path geometry directly, without a raster image or tinting pass.
Item {
    id: root
    required property string path
    property color color: "white"
    property color fillColor: "transparent"
    property real strokeWidth: 2.2
    implicitWidth: 16
    implicitHeight: 16

    Shape {
        width: 24; height: 24
        preferredRendererType: Shape.CurveRenderer
        transform: Scale { xScale: root.width / 24; yScale: root.height / 24 }
        ShapePath {
            strokeColor: root.color
            fillColor: root.fillColor
            strokeWidth: root.strokeWidth
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            PathSvg { path: root.path }
        }
    }
}
