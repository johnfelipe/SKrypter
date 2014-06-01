import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common"
import "Perm.js" as Perm
import "../alphabet.js" as Alphabet
import "../../common/Globals.js" as Globals

Item {
    id: root
    anchors.fill: parent

    property var exercise

    property bool init: true

    property string markedCipherText: secrettext.selectedText
    property string markedPlainText: plaintext.selectedText

    property string solution: Alphabet.cleanText(exercise.plainText, exercise.isCase, exercise.isBlanks ? " " : "", exercise.language)

    onMarkedCipherTextChanged: {
        button_locker.markedUpperText = markedCipherText
    }

    onMarkedPlainTextChanged: {
        button_locker.markedLowerText = markedPlainText
    }

    Column {
        spacing: 10
        anchors.fill: parent

        ButtonLocker {
            id: button_locker
            width: parent.width
            height: (parent.height - parent.spacing)*2/7
            onlyPureLetters: true
            lowerLettersColor: Globals.blue3
            showFlag: false
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

        BiTriSwitcher {
            id: bitri_switcher
            width: parent.width
            height: (parent.height - parent.spacing)*5/7
            language: exercise.language
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

        if (exercise.studentKey !== "") {
            var mapping = Perm.getMappingFromKey(exercise.studentKey)

            Alphabet.createOrUpdateAlphabet(button_locker.text_frequency_model, true, exercise.language)
            Perm.setMapping(button_locker.text_frequency_model, mapping)
        }

        button_locker.setLockedLetters(exercise.studentKeyLockedPositions)
        button_locker.updateMaps()

        init = false
    }
}
