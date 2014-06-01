import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

Button {
    id: button
    property alias source: image.source

    //iconSource does not work, scales the image wrong
    Image {
        id: image
        anchors.bottom: parent.bottom
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        fillMode: Image.PreserveAspectFit
        opacity: button.pressed || !button.enabled ? 0.5 : 1.0
    }

    style: ButtonStyle {
        background: Item {
            implicitWidth: 35
            implicitHeight: 35
        }
    }
}
