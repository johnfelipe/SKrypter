import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common"
import "Caesar.js" as Caesar
import "../alphabet.js" as Alphabet
import "../../common/Globals.js" as Globals

Rectangle {
    id: root

    property var exercise

    property int lives: 3
    color: Globals.gray1
    radius: 5.0
    width: parent.width
    height: (parent.height-parent.spacing*2)/2

    property int currentKey: text_frequency.currentKey
    property int correctKey: exercise.key
    property bool isTaskCorrect: false

    function checkNewKey() {
        plaintext.setText(Caesar.crypt(secrettext.getSimpleText(), currentKey, false))


        isTaskCorrect = (root.currentKey === root.correctKey)

        if (!isTaskCorrect) {
            lives--

            //set info for student save/print
            exercise.studentLives = lives
            exercise.studentPlainText = plaintext.getSimpleText()

            if (lives > 0) {
                intermediateResult(isTaskCorrect, correct_location)
            }
            else {
                finalResult(isTaskCorrect, correct_location)
            }
        }
        else {
            finalResult(isTaskCorrect, correct_location)
        }
    }

    Column {
        id: frequency_item
        opacity: 1
        anchors.top: parent.top
        anchors.bottom: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 10
        spacing: 10

        ListModel {
            id: language_frequency_model
        }

        ListModel {
            id: text_frequency_model
        }

        LetterRow {
            id: text_frequency
            usedModel: text_frequency_model
            outerHeight: (frequency_item.height- frequency_item.spacing)*45/100
            borderColor: Globals.pink3
        }

        FrequencyLetters {
            id: language_frequency
            usedModel: language_frequency_model
            languageFlag: exercise.language
            outerHeight: (frequency_item.height- frequency_item.spacing)*45/100
        }

        SKrypterButton {
            //: indicates that the user wishes to give it a try
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("try")

            onClicked: {
                checkNewKey()
            }
        }
    }

    Item {
        anchors.top: frequency_item.bottom
        anchors.bottom: parent.bottom
        width: parent.width

        Image {
            id: correct_location

            width: frequency_item.width
            height: frequency_item.height - lives_text.height
            anchors.verticalCenter: parent.verticalCenter
        }

        SKrypterText {
            id: correct_text
            visible: root.isTaskCorrect
            anchors.top: correct_location.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            //: should indicate that the student did really well
            text:  qsTr("awesome")
        }

        SKrypterText {
            id: lives_text
            visible: !root.isTaskCorrect
            anchors.top: correct_location.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            text: (root.lives == 0) ? qsTr("You are dead... :-(") : qsTr("You have %1 lives left!").arg(root.lives)
        }
    }


    Component.onCompleted: {
        Alphabet.createOrUpdateAlphabet(language_frequency_model, false, exercise.language)
        Alphabet.createOrUpdateAlphabet(text_frequency_model, true, exercise.language)
        Alphabet.updateStats(secrettext.getSimpleText(), text_frequency_model, true)
        Alphabet.sortModel(language_frequency_model, true)
        Alphabet.sortModel(text_frequency_model, true)
        plaintext.setText(Caesar.crypt(secrettext.getSimpleText(), currentKey, false))

        if (exercise.studentLives) {
            root.lives = exercise.studentLives
        }
    }
}
