import QtQuick 2.2

MouseArea {
    id: root

    property string baseImage: "go-previous"

    Image {
        id: image
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
        source: root.enabled ? (isPressed ? "/icons/" + baseImage + "_clicked.svg" : "/icons/" + baseImage + ".svg") : "/icons/" + baseImage + "_disabled.svg"
        sourceSize.width: root.width
        sourceSize.height: root.height

        property bool isPressed: root.pressed
    }
}
