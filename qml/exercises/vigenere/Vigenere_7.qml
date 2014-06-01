import QtQuick 2.2
import QtQuick.Layouts 1.1
import CCode 1.0

import "Vigenere.js" as Vigenere
import "../../common/Globals.js" as Globals
import "../../common"

Item {
    id: root
    property var exercise

    property real sinkovResult
    property string kasiskiResult

    //text turner variables
    property var splitTexts
    property int currentKeyLength: 1

    //friedman
    property var friedmanNumbers
    property int maxKeyLength

    property string correctKey: exercise.key

    property bool init: true

    states: [
        State {
            name: "kasiski";
        },
        State {
            name: "friedman";
        },
        State {
            name: "Sinkov";
        },
        State {
            name: "key";
        }
    ]

    ColumnLayout {
        spacing: 10
        anchors.fill: parent

        RowLayout {
            spacing: 10

            SKrypterButton {
                text: "Kasiski"

                onClicked: {
                    root.state = "kasiski"
                }
            }

            SKrypterButton {
                text: "Friedman"

                onClicked: {
                    root.state = "friedman"

                }
            }

            SKrypterButton {
                text: "Sinkov"

                onClicked: {
                    root.state = "Sinkov"
                }
            }

            Item {
                Layout.fillWidth: true
                height: 10
            }

            SKrypterText {
                text: qsTr("key length")
            }

            NumberField {
                id: user_key
                minimum: 0
                maximum: 20

                onNumberChanged: {
                    if (!init) {
                        exercise.studentKeyLength = number
                    }
                }
            }

            SKrypterButton {
                text: qsTr("set key")
                enabled: user_key.text !== ""

                onClicked: {
                    root.currentKeyLength = parseInt(user_key.text)
                    root.splitTexts = Vigenere.splitText(secrettext.getSimpleText(), root.currentKeyLength)
                    secrettext.setText(Vigenere.markCurrentText(secrettext.getSimpleText(), root.currentKeyLength, 0))
                    plaintext.setText(Vigenere.markCurrentText(Vigenere.crypt(secrettext.getSimpleText(), text_turner.userKey, false), root.currentKeyLength, text_turner.currentText))
                    text_turner.markPlaintext = true
                    root.state = "key"
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            SKrypterText {
                id: kasiski_text
                width: parent.width
                anchors.centerIn: parent
                visible: root.state === "kasiski"
                wrapMode: TextEdit.Wrap

                text: root.kasiskiResult
            }

            FriedmanGraph {
                id: graph
                anchors.fill: parent
                visible: root.state === "friedman"
            }

            SKrypterText {
                id: sinkov_text
                anchors.centerIn: parent
                visible: root.state === "Sinkov"

                text: qsTr("Sinkov Test Result: %1").arg(root.sinkovResult.toFixed(4))
            }

            Item {
                id: verification_view
                visible: root.state === "key"
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
                        if (markPlaintext) {
                            plaintext.setText(Vigenere.markCurrentText(Vigenere.crypt(secrettext.getSimpleText(), userKey, false), root.currentKeyLength, currentText))
                        }

                        if (!init) {
                            exercise.studentKey = userKey
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
        //init FRIEDMAN
        var text = secrettext.getSimpleText()
        graph.maxKeyLength = Math.min(text.replace(/ /g, "").length, 20)
        graph.initializeWithValues(Calculations.friedmanTest(text, 1, graph.maxKeyLength))
        graph.addLine(Globals.kg, "K_g")

        //init plaintext
        plaintext.setText(Vigenere.crypt(text, "_", false))
        plaintext.hasPartialSolution = false

        //init KASISKI
        var list = Calculations.calculateKasiskiXGrams(text, 3, 5, exercise.maxXGrams)

        var differences = []
        for (var i=0; i<list.length; i++) {
            for (var j=0; j<list[i].length; j+=2) {
                var positions = Vigenere.getPositions(text, list[i][j])
                differences = differences.concat(Vigenere.getDifferences(positions))
            }
        }

        var ggt = Vigenere.getGGTFromList(differences)
        //console.log("The program calculated the GGT based on the differences: " + differences.join(", ") + " as being " + ggt)
        root.kasiskiResult = qsTr("The ggT is %1. It is based on the following differences: %2").arg(ggt).arg(differences.join(", "))


        //init FRIEDMAN
        graph.addLine(Globals.kd[exercise.language], "K_d")

        //init Sinkov
        root.sinkovResult = Calculations.sinkovTest(text, Globals.kd[exercise.language], Globals.kg)

        //student
        if (exercise.studentKeyLength !== -1) {
            if (exercise.studentKey !== "") {
                text_turner.userKey = exercise.studentKey
            }

            user_key.text = exercise.studentKeyLength
            currentKeyLength = user_key.number
            splitTexts = Vigenere.splitText(secrettext.getSimpleText(), root.currentKeyLength)
            secrettext.setText(Vigenere.markCurrentText(secrettext.getSimpleText(), root.currentKeyLength, 0))
            plaintext.setText(Vigenere.markCurrentText(Vigenere.crypt(secrettext.getSimpleText(), text_turner.userKey, false), exercise.studentKeyLength, 0))
            text_turner.markPlaintext = true
            root.state = "key"
        }
        init = false
    }
}
