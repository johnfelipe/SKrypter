import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common"
import "../../common/Globals.js" as Globals
import "Perm.js" as Perm
import "../alphabet.js" as Alphabet

Item {
    id: root

    property var exercise

    anchors.fill: parent

    property string markedCipherText: secrettext.selectedText
    property string markedPlainText: plaintext.selectedText

    property string solution: Alphabet.cleanText(exercise.plainText, exercise.isCase, exercise.isBlanks ? " " : "", exercise.language)

    property bool init: true

    onMarkedCipherTextChanged: {
        button_locker.markedUpperText = markedCipherText
    }

    onMarkedPlainTextChanged: {
        button_locker.markedLowerText = markedPlainText
    }

    QuestionBox {
        id: sort_message_box
        anchors.fill: parent
        anchors.margins: 5
        visible: false
        z: 2
        text: qsTr("If you sort, all locked letters will be unlocked. Are you sure that you want to sort?")
    }

    ButtonLocker {
        id: button_locker
        width: parent.width
        height: parent.height - button_row.height - 10
        text: secrettext.getSimpleText()
        language: exercise.language
        calculateFullMap: true

        onMapChanged: {
            var output_text = Perm.crypt(secrettext.getSimpleText(), map)
            plaintext.setText(output_text)

            if (output_text === solution) {
                finalResult(true)
            }

            var keyString = Perm.generateKeyString(button_repeater, language_frequency_model)
            exercise.studentKeyLockedPositions = keyString
        }

        onFullMapEncryptionChanged: {
            if (!init && fullMapEncryption) {
                var key = Perm.getKeyFromMapping(fullMapEncryption)
                exercise.studentKey = key
            }
        }
    }

    Row {
        id: button_row
        spacing: 10
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        function sortButtonFunction(sortByLetters) {
            if (button_locker.hasLockedLetters) {
                sort_message_box.okFunction = function() {
                    Alphabet.sortModel(button_locker.text_frequency_model, sortByLetters)
                    Alphabet.sortModel(button_locker.language_frequency_model, sortByLetters)
                    button_locker.button_repeater.unlockAll()
                    button_locker.remarkLetters()
                    exercise.hiddenSortByLetters = sortByLetters
                }
                sort_message_box.visible = true
            }
            else {
                Alphabet.sortModel(button_locker.text_frequency_model, sortByLetters)
                Alphabet.sortModel(button_locker.language_frequency_model, sortByLetters)
                button_locker.remarkLetters()
                button_locker.updateMaps()
                exercise.hiddenSortByLetters = sortByLetters
            }
        }

        SKrypterButton {
            text: qsTr("sort alphabetically")
            anchors.verticalCenter: parent.verticalCenter

            onClicked: {
                button_row.sortButtonFunction(true)
            }
        }

        SKrypterButton {
            text: qsTr("sort by percentage")
            anchors.verticalCenter: parent.verticalCenter

            onClicked: {
                button_row.sortButtonFunction(false)
            }
        }
    }

    property string plainText: plaintext.getSimpleText()
    onPlainTextChanged: {
        exercise.studentPlainText = plainText
    }

    Component.onCompleted: {
        // Set solution, necessary so that partial plaintext can be corrected
        plaintext.setInitialTextForPartial(Perm.createPartialPlaintext(exercise.plainText, exercise.keyLockedPositions))

        Alphabet.createOrUpdateAlphabet(button_locker.language_frequency_model, false, exercise.language)
        Alphabet.sortModel(button_locker.language_frequency_model, exercise.hiddenSortByLetters)

        if (exercise.studentKey !== "") {
            var mapping = Perm.getMappingFromKey(exercise.studentKey)

            if (!exercise.hiddenSortByLetters) {
                mapping = Perm.getMappingForUnorderedBase(button_locker.language_frequency_model, mapping)
            }

            Alphabet.createOrUpdateAlphabet(button_locker.text_frequency_model, true, exercise.language)
            Perm.setMapping(button_locker.text_frequency_model, mapping)
        }

        button_locker.setLockedLetters(exercise.studentKeyLockedPositions)
        button_locker.updateMaps()

        init = false
    }
}
