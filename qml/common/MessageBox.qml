import QtQuick 2.0
import QtQuick.Controls 1.1

import "Globals.js" as Globals

Rectangle {
    id: messageBox

    property string text

    color: "transparent"
    focus: true

    Rectangle {
        anchors.fill: parent
        opacity: 0.7
        MouseArea {
            anchors.fill: parent
        }
    }

    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        height: message_text.height + 20 + ok_button.height + 10 //parent.height/1.5
        width: parent.width/2
        opacity: 1
        border.color: Globals.orange4
        border.width: 4

        SKrypterText {
            id: message_text
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 10
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            text: messageBox.text
        }

        SKrypterButton {
            id: ok_button
            anchors.top: message_text.bottom
            anchors.left: parent.left
            anchors.margins: 5
            text: qsTr("Ok")
            width: 92
            onClicked: {
                messageBox.visible = false
            }
        }

    }
}
