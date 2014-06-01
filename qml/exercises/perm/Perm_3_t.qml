import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common/"
import "../../common/Globals.js" as Globals
import "../alphabet.js" as Alphabet
import "Perm.js" as Perm

Item {
    id: root

    property var exercise

    property bool init: true

    property string language: exercise.language

    onLanguageChanged: {
        Alphabet.createOrUpdateAlphabet(button_locker.language_frequency_model, false, exercise.language)
        Alphabet.sortModel(button_locker.language_frequency_model, false)
        button_locker.updateMaps()
    }

    //stores the encryption mapping (which acts as key), used to update ciphertext
    property var mapping: button_locker.fullMapEncryption

    function secrettextUpdateFunction() {
        if (button_locker.text_frequency_model.count > 0 && mapping) {
            secrettext.setText(Alphabet.cleanText(Perm.crypt(plaintext.getSimpleText(), mapping),
                                                   exercise.isCase, exercise.isBlanks ? " " : "", exercise.language))
        }
    }

    onMappingChanged: {
        //necessary to avoid function call upon initializing cipher_model
        if (!init) {
            secrettextUpdateFunction()
            var key = Perm.getKeyFromMapping(mapping)
            exercise.key = key
        }
    }

    //responsible for reading all locked positions from file when opening existing exercise
    //and writing to file when changing or creating a new exercise
    property string keyLockedPositions: exercise.keyLockedPositions

    onKeyLockedPositionsChanged: {
        //needed to avoid overwriting read data from file upon initializing
        if (!init) {
            exercise.keyLockedPositions = keyLockedPositions
        }
        //mark plainText to indicate available letters
        plaintext.setText(Perm.markGivenLetters(plaintext.getSimpleText(), keyLockedPositions))
    }

    //responsible for both reading and writing the key used for this exercise
    property string key: exercise.key

    Column {
        id: col_lay
        anchors.fill: parent
        spacing: 10

        TeacherComponent {
            id: base
            anchors.horizontalCenter: parent.horizontalCenter
            type: "Perm3Exercise"
            updateFunction: secrettextUpdateFunction
        }

        ButtonLocker {
            id: button_locker
            width: parent.width
            height: parent.height - base.height - button.height - 2*col_lay.spacing
            text: secrettext.getSimpleText()
            calculateFullMap: true
            language: exercise.language

            onMapChanged: {
                //if the map changes, the button_repeater may have changed locked positions
                //this is a workaround as onButton_repeaterChanged does not fire when user changes it
                //update lockedLetters
                var keyString = Perm.generateKeyString(button_repeater, language_frequency_model)

                root.keyLockedPositions = keyString
            }
        }
    }

    SKrypterButton {
        id: button
        text: qsTr("generate random key")
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        onClicked: {
            Alphabet.sortModelRandomly(button_locker.text_frequency_model)
            Alphabet.updateStats(button_locker.text, button_locker.text_frequency_model, true)
            button_locker.updateMaps()
        }
    }

    SKrypterButton {
        text: qsTr("mark letters")
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        onClicked: {
            plaintext.setText(Perm.markGivenLetters(plaintext.getSimpleText(), keyLockedPositions))
        }
    }

    Component.onCompleted: {
        Alphabet.createOrUpdateAlphabet(button_locker.language_frequency_model, false, exercise.language)
        Alphabet.sortModel(button_locker.language_frequency_model, false)

        if (exercise.key !== "") {
            var mapping = Perm.getMappingFromKey(exercise.key)
            mapping = Perm.getMappingForUnorderedBase(button_locker.language_frequency_model, mapping)

            Alphabet.createOrUpdateAlphabet(button_locker.text_frequency_model, true, language)
            Perm.setMapping(button_locker.text_frequency_model, mapping)
            Alphabet.updateStats(exercise.cipherText, button_locker.text_frequency_model, true)
        }

        button_locker.setLockedLetters(exercise.keyLockedPositions)
        button_locker.updateMaps()

        root.init = false
    }
}
