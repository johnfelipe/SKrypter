import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "common"

/**
 * This class is creates the main menu where all cryptosystems are displayed.
 */
Item {
    anchors.fill: parent

    property var exercise_model: [

        {
            "picture": "/images/caesar/caesar_menu.png",
            "title": "Caesar",
            "file": "exercises/caesar/CaesarMain.qml",
            "helpTitle": qsTr("Overview Help Caesar"),
            "helpText": qsTr("Overview Caesar Help Text")
        },

        {
            "picture": "/images/perm/perm_menu.png",
            "title": "Perm",
            "file": "exercises/perm/PermMain.qml",
            "helpTitle": qsTr("Overview Help Perm"),
            "helpText": qsTr("Overview Perm Help Text")
        },

        {
            "picture": "/images/vigenere/vigenere_menu.png",
            "title": "Vigenère",
            "file": "exercises/vigenere/VigenereMain.qml",
            "helpTitle": qsTr("Overview Help Vigenère"),
            "helpText": qsTr("Overview Vigenère Help Text")
        },
    ]

    PageTurner {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: about.top
        menu_list: exercise_model

        delegate: Item {
            width: 180
            height: 210

            SKrypterButton {
                id: exercise_button
                width: (model.title === "Dummy") ? 0 : 180
                height: (model.title === "Dummy") ? 0 : 180
                anchors.top: parent.top

                Image {
                    anchors.fill: parent
                    source: model.picture
                    fillMode: Image.PreserveAspectCrop
                }

                onClicked: {
                    loadNewScreen(model.file, {helpTitle: model.helpTitle, helpText: model.helpText})
                }
            }

            SKrypterText {
                anchors {
                    top: exercise_button.bottom
                    bottom: parent.bottom
                    margins: 5
                    horizontalCenter: parent.horizontalCenter
                }
                font {
                    capitalization: Font.SmallCaps
                    bold: true
                    pixelSize: 18
                    letterSpacing: 2
                }
                text: (model.title === "Dummy") ? "" : model.title
            }
        }
    }


    SKrypterButton {
        id: about
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: qsTr("About")
        onClicked: {
            loadNewScreen("/qml/About.qml", {})
        }

    }
}
