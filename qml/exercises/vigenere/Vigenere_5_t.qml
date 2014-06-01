import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

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
        }
        updateGraph()
    }

    function updateGraph() {
        var text = secrettext.getSimpleText()
        graph.maxKeyLength = Math.min(text.replace(/ /g, "").length, 20)
        graph.initializeWithValues(Calculations.friedmanTest(text, 1, graph.maxKeyLength))
    }

    Item {
        id: main
        anchors.top: parent.top
        height: parent.height/2
        width: parent.width

        ColumnLayout {
            anchors.centerIn: parent

            TeacherComponent {
                type: "Vigenere5Exercise"
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
                    text: exercise.key

                    verticalAlignment: TextInput.AlignVCenter

                    onTextChanged: {
                        exercise.key = key.text
                        secrettextUpdateFunction()
                    }
                }
            }
        }
    }

    FriedmanGraph {
        id: graph
        anchors.top: main.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    property var language: exercise.language
    onLanguageChanged: {
        graph.addLine(Globals.kd[language], "K_d")
        updateGraph()
    }

    Component.onCompleted: {
        var text = secrettext.getSimpleText()
        graph.maxKeyLength = Math.min(text.replace(/ /g, "").length, 20)
        graph.initializeWithValues(Calculations.friedmanTest(text, 1, graph.maxKeyLength))
        graph.addLine(Globals.kg, "K_g")
        updateGraph()
    }
}

