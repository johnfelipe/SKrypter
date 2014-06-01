import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1

import "../../common/"
import "../../common/Globals.js" as Globals
import "../alphabet.js" as Alphabet
import "Vigenere.js" as Vigenere

import CCode 1.0

Item {
    id: root

    property var exercise

    function secrettextUpdateFunction() {
        if (key.text === "") {
            secrettext.setText("")
        }
        else {
            secrettext.setText(Alphabet.cleanText(Vigenere.crypt(plaintext.getSimpleText(), key.text, true),
                               exercise.isCase, exercise.isBlanks ? " " : "", exercise.language))
            timer.restart()
        }
    }

    Timer {
        id: timer
        interval: 500;
        onTriggered: {
            calculateKasiski()
        }
    }

    function calculateKasiski() {
        //init KASISKI
        var list = Calculations.calculateKasiskiXGrams(secrettext.getSimpleText(), 3, 5, exercise.maxXGrams)

        var text = secrettext.getSimpleText()
        var differences = []
        for (var i=0; i<list.length; i++) {
            for (var j=0; j<list[i].length; j+=2) {
                var positions = Vigenere.getPositions(text, list[i][j])
                differences = differences.concat(Vigenere.getDifferences(positions))
            }
        }

        if (differences.length === 0) {
            ggt_text.text = qsTr("There are no repeating patterns in the entered text. Please add more plain text.")
        }
        else {
            var ggt = Vigenere.getGGTFromList(differences)
            ggt_text.text = qsTr("The program calculated the GGT based on the shown repeating patterns as %1. This is based on the following differences: %2").arg(ggt).arg(differences.join(", "))
        }
    }

    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: ggt_text.top


        ColumnLayout {
            anchors.centerIn: parent

            TeacherComponent {
                type: "Vigenere3Exercise"
                updateFunction: secrettextUpdateFunction
            }

            Row {
                spacing: 10

                SKrypterText {
                    text: qsTr("Key:")
                    anchors.baseline: key.baseline
                }

                CleanTextField {
                    id: key

                    verticalAlignment: TextInput.AlignVCenter

                    onTextChanged: {
                        exercise.key = key.text
                        secrettextUpdateFunction()
                    }
                }
            }

            Row {
                spacing: 10

                SKrypterText {
                    text: qsTr("xGram limit:")
                    anchors.baseline: max_xgrams.baseline
                }

                NumberField {
                    id: max_xgrams
                    minimum: 1
                    maximum: 10
                    text: exercise.maxXGrams

                    verticalAlignment: TextInput.AlignVCenter

                    onTextChanged: {
                        if (max_xgrams.text == "") {
                            exercise.maxXGrams = 3
                        }
                        else {
                            exercise.maxXGrams = parseInt(max_xgrams.text)
                        }
                        calculateKasiski()
                    }
                }
            }
        }
    }

    TextArea {
        id: ggt_text
        readOnly: true
        wrapMode: TextEdit.Wrap
        anchors.bottom: parent.bottom
        width: parent.width

        style: TextAreaStyle {
            backgroundColor: Globals.orange1
            textColor: "black"

        }
    }

    Component.onCompleted: {
        calculateKasiski()
        key.text = exercise.key
    }
}
