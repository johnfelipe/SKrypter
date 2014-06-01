import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common/"
import "../../common/Globals.js" as Globals
import "Perm.js" as Perm
import "../alphabet.js" as Alphabet

Item {
    id: root

    property var exercise

    property string exerciseType

    property bool isLockable: true

    property bool init: true

    property string language: exercise.language

    onLanguageChanged: {
        Alphabet.createOrUpdateAlphabet(button_locker.language_frequency_model, false, exercise.language)
        Alphabet.sortModel(button_locker.language_frequency_model, false)
        button_locker.updateMaps()
    }

    //updates the ciphertext when the plaintext changes
    function secrettextUpdateFunction() {
        if (button_locker.text_frequency_model.count > 0 && mapping) {
            secrettext.setText(Alphabet.cleanText(Perm.crypt(plaintext.getSimpleText(), mapping),
                               exercise.isCase, exercise.isBlanks ? " " : "", exercise.language))
        }
    }

    //stores the encryption mapping (which acts as key), used to update ciphertext
    property var mapping: button_locker.fullMapEncryption

    property string ignoreCharacters: exercise.isBlanks ? " " : ""

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
    property string keyLockedPositions: isLockable ? exercise.keyLockedPositions : ""

    onKeyLockedPositionsChanged: {
        if (isLockable) {
            //needed to avoid overwriting read data from file upon initializing
            if (!init) {
                exercise.keyLockedPositions = keyLockedPositions
            }
            //mark plainText to indicate available letters
            plaintext.setText(Perm.markGivenLetters(plaintext.getSimpleText(), keyLockedPositions))
        }
    }

    //responsible for both reading and writing the key used for this exercise
    property string key: exercise.key

    Column {
        id: col_lay
        anchors.fill: parent
        spacing: 10

        RowLayout {
            id: teacher_controls
            width: parent.width
            spacing: 10

            Item {
                Layout.fillWidth: true
                height: parent.height
            }

            TeacherComponent {
                type: root.exerciseType
                updateFunction: secrettextUpdateFunction
            }

            Column {
                anchors.top: parent.top
                spacing: 10

                SKrypterButton {
                    text: qsTr("Single Letter Analysis")

                    onClicked: {
                        single_view.visible = true
                        bigram_view.visible = false
                        trigram_view.visible = false
                    }
                }

                SKrypterButton {
                    text: qsTr("Bigram Analysis")

                    onClicked: {
                        single_view.visible = false
                        bigram_view.visible = true
                        trigram_view.visible = false

                    }
                }

                SKrypterButton {
                    text: qsTr("Trigram Analysis")

                    onClicked: {
                        single_view.visible = false
                        bigram_view.visible = false
                        trigram_view.visible = true

                    }
                }
            }

            Item {
                Layout.fillWidth: true
                height: parent.height
            }
        }

        //SINGLE frequencies view
        Item {
            id: single_view
            height: parent.height - teacher_controls.height - col_lay.spacing
            width: parent.width

            ButtonLocker {
                id: button_locker
                width: parent.width
                height: parent.height - button.height
                text: single_view.visible ? secrettext.getSimpleText() : ""
                calculateFullMap: true
                isLockable: root.isLockable
                language: exercise.language

                onMapChanged: {
                    if (isLockable) {
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
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("generate random key")

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
        }

        //BIGRAM view
        Item {
            id: bigram_view
            height: parent.height - teacher_controls.height - col_lay.spacing
            width: parent.width
            visible: false

            XGramView {
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height

                xgramLength: 2
                numberOfXgrams: 10
                plainText: Alphabet.cleanText(plaintext.getSimpleText(), exercise.isCase, exercise.isBlanks ? " " : "", exercise.language)
                teacherMode: true
                mapping: root.mapping
                text: bigram_view.visible ? secrettext.getSimpleText() : ""

                language: exercise.language

                onSelectedXgramChanged: {
                    secrettext.text = Alphabet.markXGrams(secrettext.getSimpleText(), selectedXgram)
                }

            }

        }

        //TRIGRAM view
        Item {
            id: trigram_view
            height: parent.height - teacher_controls.height - col_lay.spacing
            width: parent.width
            visible: false

            XGramView {
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height

                xgramLength: 3
                numberOfXgrams: 10
                plainText: Alphabet.cleanText(plaintext.getSimpleText(), exercise.isCase, exercise.isBlanks ? " " : "", exercise.language)
                teacherMode: true
                mapping: root.mapping
                text: trigram_view.visible ? secrettext.getSimpleText() : ""

                language: exercise.language

                onSelectedXgramChanged: {
                    secrettext.text = Alphabet.markXGrams(secrettext.getSimpleText(), selectedXgram)
                }
            }
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

        if (root.isLockable) {
            button_locker.setLockedLetters(exercise.keyLockedPositions)
            button_locker.updateMaps()
        }

        root.init = false
    }
}
