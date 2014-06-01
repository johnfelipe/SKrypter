import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "Vigenere.js" as Vigenere
import "../alphabet.js" as Alphabet
import "../../common"

Item {
    id: root
    anchors.margins: 5

    //public
    property int numberOfTexts
    property var splitTexts //array
    property string userKey: ""
    property bool isKeyFinished: false
    property bool keyVisible: true

    property string language

    property int currentText: 0

    //workaround cause splitTexts not set when component completed
    onSplitTextsChanged: {
        if (splitTexts) {
            Alphabet.updateStats(splitTexts[currentText], text_frequency_model, true)
        }
    }

    onCurrentTextChanged: {
        Alphabet.updateStats(splitTexts[currentText], text_frequency_model, true)
        var shiftPos = Alphabet.charCodeToIndex(userKey.charCodeAt(currentText))
        if (shiftPos === -1) {
            shiftPos = 0
        }

        text_frequency.setCurrentKey(shiftPos)
        //Alphabet.shiftModelToLetter(text_frequency_model, shiftPos)

    }

    Item {
        //Navigation to previous page! Can only navigate to previous page if a previous page exists!
        id: prev_rectangle
        width: 50
        height: parent.height
        anchors.left: parent.left

        property bool isPressed: false

        Image {
            id: previous_image
            anchors.verticalCenter: parent.verticalCenter
            source: prev_rectangle.isPressed ? "/icons/go-previous_clicked.svg" : "/icons/go-previous.svg"

            MouseArea {
                id: prev_mouse_area

                anchors.fill: parent

                onClicked: {
                    root.currentText = (root.numberOfTexts + root.currentText-1) % root.numberOfTexts

                }

                onPressed: {
                    prev_rectangle.isPressed = true
                }
                onReleased: {
                    prev_rectangle.isPressed = false
                }
            }
        }
    }

    Rectangle {
        id: main_menu_rectangle
        anchors.left: prev_rectangle.right
        anchors.right: next_rectangle.left
        anchors.top: parent.top
        anchors.bottom: text_rectangle.top
        radius: 5.0
        border.color: "black"
        color: "transparent"
        border.width: 2


        Item {
            anchors.fill: parent
            anchors.margins: 5

            //            TextArea {
            //                id: text_area
            //                anchors.top: parent.top
            //                width: parent.width
            //                height: 50
            //                text: root.splitTexts[root.currentText] ? root.splitTexts[root.currentText] : ""
            //                wrapMode: TextEdit.Wrap
            //            }

            Column {
                id: frequency_item
                anchors.fill: parent
                //anchors.top: text_area.bottom
                //width: parent.width
                //anchors.bottom: parent.bottom

                ListModel {
                    id: language_frequency_model
                }

                ListModel {
                    id: text_frequency_model
                }

                LetterRow {
                    id: text_frequency
                    usedModel: text_frequency_model
                    outerHeight: (frequency_item.height- frequency_item.spacing)/2
                    borderColor: "black"
                }

                FrequencyLetters {
                    id: language_frequency
                    usedModel: language_frequency_model
                    languageFlag: root.language
                    outerHeight: (frequency_item.height- frequency_item.spacing)/2
                }


            }
        }

    }

    Item {
        //used to indicate on which page the user currently is
        id: text_rectangle
        anchors.left: prev_rectangle.right
        anchors.right: next_rectangle.left
        height: 50
        anchors.bottom: parent.bottom

        property int currentText: root.currentText

        SKrypterText {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            font {
                pixelSize: 16
            }
            text: qsTr("Text %1 of %2").arg(text_rectangle.currentText + 1).arg(root.numberOfTexts)
        }
    }


    Item {
        //Navigation to next page! Can only navigate to next page if a next page exists!
        id: next_rectangle
        height: parent.height
        anchors.right: parent.right
        width: 50

        property bool isPressed: false

        Image {
            id: next_image
            anchors.verticalCenter: parent.verticalCenter
            source: next_rectangle.isPressed ? "/icons/go-next_clicked.svg" : "/icons/go-next.svg"

            MouseArea {
                id: next_mouse_area
                anchors.fill: parent
                onClicked: {
                    root.currentText = (root.currentText + 1) % root.numberOfTexts

                }

                onPressed: {
                    next_rectangle.isPressed = true
                }
                onReleased: {
                    next_rectangle.isPressed = false
                }
            }
        }

    }

    Row {
        id: key_row
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 10
        visible: keyVisible

        SKrypterButton {
            text: root.userKey[root.currentText] === "_" ? qsTr("set key") : qsTr("update key")

            onClicked: {
                root.userKey = Alphabet.updateAtIndex(root.userKey, root.currentText, Alphabet.indexToUpperString(text_frequency.currentKey))
                if (userKey.search("_") === -1) {
                    isKeyFinished = true
                }
            }
        }

        SKrypterText {
            text: qsTr("current Key: %1").arg(Vigenere.markCurrentText(root.userKey, root.numberOfTexts, root.currentText))
        }
    }

    onNumberOfTextsChanged: {
        if (root.userKey.length !== numberOfTexts) {
            root.userKey = ""
            root.currentText = 0
            for (var i=0; i<root.numberOfTexts; i++) {
                root.userKey += "_"
            }
        }
    }

    onLanguageChanged: {
        Alphabet.createOrUpdateAlphabet(language_frequency_model, false, root.language)
        Alphabet.createOrUpdateAlphabet(text_frequency_model, true, root.language)
        if (splitTexts && splitTexts[currentText]) {
            Alphabet.updateStats(splitTexts[currentText], text_frequency_model, true)
        }
    }
}
