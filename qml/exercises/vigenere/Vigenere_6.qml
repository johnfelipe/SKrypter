import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import CCode 1.0

import "Vigenere.js" as Vigenere
import "../../common/Globals.js" as Globals
import "../../common"

Item {
    id: root

    property var exercise
    property var splitTexts
    property int currentKeyLength: 0
    property int keyLenghtSolution: exercise.key.length

    property bool init: true

    ColumnLayout {
        anchors.fill: parent
        spacing: 5

        Row {
            spacing: 10


            SKrypterButton {
                id: sinkov_button
                text: qsTr("Sinkov Test")
                enabled: true
                onClicked: {
                    sinkovClicked()
                }

                function sinkovClicked() {
                    var sinkovTest = Calculations.sinkovTest(secrettext.getSimpleText(), Globals.kd[exercise.language], Globals.kg)
                    root.currentKeyLength = Math.round(sinkovTest)

                    if (root.currentKeyLength === 0) {
                        console.warn("Sinkov Test for text " + secrettext.getSimpleText() + " results in key length of 0")
                        root.currentKeyLength = 1
                    }

                    exercise.studentKeyLength = root.currentKeyLength

                    sinkov_text.text = sinkovTest.toFixed(4)
                    key_label.visible = true
                    enabled = false

                    root.splitTexts = Vigenere.splitText(secrettext.getSimpleText(), root.currentKeyLength)
                    secrettext.setText(Vigenere.markCurrentText(secrettext.getSimpleText(), root.currentKeyLength, 0))
                    plaintext.setText(Vigenere.markCurrentText(Vigenere.crypt(secrettext.getSimpleText(), text_turner.userKey, false), root.currentKeyLength, text_turner.currentText))
                    text_turner.markPlaintext = true
                    verification_view.visible = true
                }
            }

            SKrypterText {
                id: sinkov_text
            }

            Item {
                width: 50
                height: 10
            }

            SKrypterText {
                id: key_label
                visible: false
                text: qsTr("Rounded key length: %1").arg(root.currentKeyLength)
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Item {
                id: verification_view
                visible: false
                anchors.fill: parent

                property var partialKeys: [] //contains all keys that were set in the text turner

                TextTurner {
                    id: text_turner
                    anchors.fill: parent
                    numberOfTexts: root.currentKeyLength
                    splitTexts: root.splitTexts
                    property bool markPlaintext: false
                    language: exercise.language

                    onCurrentTextChanged: {
                        secrettext.setText(Vigenere.markCurrentText(secrettext.getSimpleText(), root.currentKeyLength, currentText))
                        plaintext.setText(Vigenere.markCurrentText(plaintext.getSimpleText(), root.currentKeyLength, currentText))
                    }

                    onUserKeyChanged: {
                        if (markPlaintext) {
                            plaintext.setText(Vigenere.markCurrentText(Vigenere.crypt(secrettext.getSimpleText(), userKey, false), root.currentKeyLength, currentText))
                        }

                        if (!init) {
                            exercise.studentKeyForFirstPart = userKey
                        }
                    }
                }

                Row {
                    id: final_solution_row
                    visible: text_turner.isKeyFinished
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    spacing: 5

                    onVisibleChanged: {
                        if (visible) {
                            text_turner.keyVisible = false
                        }
                    }

                    SKrypterText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Sinkov estimation correct?")
                    }

                    SKrypterButton {
                        width: 40
                        text: qsTr("yes")

                        onClicked: {
                            if (root.currentKeyLength === root.keyLenghtSolution) {
                                finalResult(true)
                                // Remove colors
                                plaintext.setText(plaintext.getSimpleText())
                                secrettext.setText(secrettext.getSimpleText())
                            }
                            else {
                                intermediateResult(false)
                                text_turner.isKeyFinished = false
                                text_turner.keyVisible = true
                            }
                        }
                    }

                    SKrypterButton {
                        width: 40
                        text: qsTr("no")

                        onClicked: {
                            if (root.currentKeyLength !== root.keyLenghtSolution) {
                                intermediateResult(true)
                                message_box.visible = true
                            }
                            else {
                                intermediateResult(false)
                                text_turner.isKeyFinished = false
                            }
                        }
                    }
                }
            }
        }
    }

    QuestionBox {
        id: message_box
        anchors.fill: parent
        visible: false
        z: 2
        text: qsTr("You have successfully completed the task. Unfortunately the Sinkov test did not result in the correct key length.\nDo you want to find the correct key now?")
        okFunction: function() {
            // Want to load directly vigenere cont, but only if in student mode!
            if (!_view.isTeacherProgram()) {
                exercise.qmlFile = "vigenere/Vigenere_cont.qml"
            }

            var newModel = {}
            newModel.qmlFile = "vigenere/Vigenere_cont.qml"
            newModel.helpTitle = qsTr("Vigenere: Extra Task")
            newModel.helpText = qsTr("Take into account that you first have to change the key length.")
            var newExercises = []
            exercise.studentKeyLength = root.currentKeyLength
            newExercises[0] = exercise
            newModel.exercises = newExercises
            main_loader.setCurrentExercise(0)
            loadNewScreen("/qml/exercises/DidacticScenario.qml", newModel)
        }

        cancelFunction: function() {
            finalResult(true)
        }
    }

    Component.onCompleted: {
        plaintext.setText(Vigenere.crypt(secrettext.getSimpleText(), "_", false))
        plaintext.hasPartialSolution = false

        if (exercise.studentKeyLength !== -1) {
            sinkov_button.sinkovClicked()
            if (exercise.studentKeyForFirstPart !== "") {
                text_turner.userKey = exercise.studentKeyForFirstPart
            }
        }

        init = false
    }
}
