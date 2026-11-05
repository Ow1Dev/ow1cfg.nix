import QtQuick
import "../core"

Item {
    id: root
    implicitWidth: 18
    implicitHeight: 18
    Canvas {
        anchors.fill: parent
        onPaint: {
            const ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            ctx.beginPath();
            ctx.arc(width / 2, height / 2, Math.min(width, height) / 2 - 2, -Math.PI / 2, Math.PI);
            ctx.lineWidth = 2.5;
            ctx.lineCap = "round";
            ctx.strokeStyle = Nord.accent.toString();
            ctx.stroke();
        }
    }
    RotationAnimator on rotation { from: 0; to: 360; duration: 850; loops: Animation.Infinite; running: root.visible }
}
