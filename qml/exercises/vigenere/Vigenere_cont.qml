import QtQuick 2.2
import QtQuick.Layouts 1.1
import CCode 1.0

import "Vigenere.js" as Vigenere
import "../../common"

Item {
    id: root

    property var exercise

    //text turner variables
    property var splitTexts
    property int currentKeyLength: 1

    property bool init: true

    property string correctKey: exercise.key

    ColumnLayout {
        spacing: 10
        anchors.fill: parent

        RowLayout {
            spacing: 10

            SKrypterText {
                text: qsTr("key length")
            }

            NumberField {
                id: user_key
                minimum: 1
                maximum: 20

                onNumberChanged: {
                    if (!init) {
                        exercise.studentKeyLength = number
                    }
                }
            }

            SKrypterButton {
                text: qsTr("set key")
                enabled: user_key !== ""

                onClicked: {
                    root.currentKeyLength = parseInt(user_key.text)
                    root.splitTexts = Vigenere.splitText(secrettext.getSimpleText(), root.currentKeyLength)
                    secrettext.setText(Vigenere.markCurrentText(secrettext.getSimpleText(), root.currentKeyLength, 0))
                    plaintext.setText(Vigenere.markCurrentText(plaintext.getSimpleText(), root.currentKeyLength, 0))
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Item {
                id: verification_view
                anchors.fill: parent

                property var partialKeys: [] //contains all keys that were set in the text turner

                TextTurner {
                    id: text_turner
                    anchors.fill: parent
                    numberOfTexts: root.currentKeyLength
                    splitTexts: root.splitTexts
                    language: exercise.language

                    property bool markPlaintext: false

                    onCurrentTextChanged: {
                        secrettext.setText(Vigenere.markCurrentText(secrettext.getSimpleText(), root.currentKeyLength, currentText))
                        plaintext.setText(Vigenere.markCurrentText(plaintext.getSimpleText(), root.currentKeyLength, currentText))
                    }

                    onUserKeyChanged: {
                        plaintext.setText(Vigenere.markCurrentText(Vigenere.crypt(secrettext.getSimpleText(), userKey, false), root.currentKeyLength, currentText))
                        if (!init) {
                            exercise.studentKeyForSecondPart = userKey
                        }
                    }

                    onIsKeyFinishedChanged: {
                        if (isKeyFinished) {
                            if (userKey === root.correctKey) {
                                finalResult(true)
                                // Remove colors
                                plaintext.setText(plaintext.getSimpleText())
                                secrettext.setText(secrettext.getSimpleText())
                            }
                            else {
                                intermediateResult(false)
                                isKeyFinished = false
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        //init plaintext
        plaintext.hasPartialSolution = false
        plaintext.ignoreUnderscores = true

        if (exercise.studentKeyForSecondPart !== "") {
            text_turner.userKey = exercise.studentKeyForSecondPart
        }

        user_key.text = exercise.studentKeyLength
        currentKeyLength = user_key.number
        splitTexts = Vigenere.splitText(secrettext.getSimpleText(), root.currentKeyLength)
        secrettext.setText(Vigenere.markCurrentText(secrettext.getSimpleText(), root.currentKeyLength, 0))
        plaintext.setText(Vigenere.markCurrentText(Vigenere.crypt(secrettext.getSimpleText(), text_turner.userKey, false), exercise.studentKeyLength, 0))

        init = false
    }
}
