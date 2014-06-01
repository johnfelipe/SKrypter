import QtQuick 2.2

/**
 * This class creates an interactive Caesar wheel based on
 * three images. The inner circle can be rotated either by
 * the user or automatically based on the key property.
 */
Item {
    id: root

    // Public
    property int key: 0
    property bool draggingChangesKey: false
    property bool showNeedle: true

    // Private
    // Current angle of the inner wheel with respect to outer wheel
    property real angle: 0

    Image {
        id: outerRing
        anchors.fill: parent
        source: "/images/caesar/caesar_outer.png"
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: innerRing
        source: "/images/caesar/caesar_inner.png"
        anchors.fill: outerRing
        fillMode: Image.PreserveAspectFit
        rotation: root.angle + 360 - key * 360 / 26

        Behavior on rotation {
            id: behavior_rotation
            RotationAnimation {
                id: wheel_animation
                duration: 1000
                direction: RotationAnimation.Shortest
                easing.type: Easing.InOutQuad
            }
        }
    }

    Image {
        visible: root.showNeedle
        source: "/images/caesar/caesar_needle.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: outerRing
    }

    MouseArea {
        id: mouse_area

        // Angle when the user clicks
        property real startAngle: 0

        anchors.centerIn: outerRing
        width: outerRing.paintedWidth
        height: outerRing.paintedHeight

        cursorShape: root.opacity == 0 || !enabled ? Qt.ArrowCursor : (pressed ? Qt.ClosedHandCursor : Qt.OpenHandCursor)
        enabled: !wheel_animation.running

        function getCurrentAngle() {
            var xPos = mouse_area.mouseX - width/2
            var yPos = mouse_area.mouseY - height/2
            return Math.atan2(yPos, xPos)*180/Math.PI
        }

        onPressed: {
            behavior_rotation.enabled = false
            startAngle = getCurrentAngle()
        }

        onPositionChanged: {
            root.angle = getCurrentAngle() - startAngle
        }

        onReleased: {
            behavior_rotation.enabled = true

            if (root.draggingChangesKey) {
                root.key = (root.key + 26 - Math.round(root.angle / (360/26))) % 26
            }

            root.angle = 0
        }
    }
}
