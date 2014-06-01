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

    property real sinkov

    onSinkovChanged: {
        exercise.sinkov = root.sinkov
    }

    property string plainText: plaintext.getSimpleText()
    function secrettextUpdateFunction() {
        if (key.text !== "") {
            secrettext.setText(Alphabet.cleanText(Vigenere.crypt(plaintext.getSimpleText(), key.text, true),
                               exercise.isCase, exercise.isBlanks ? " " : "", exercise.language))
        }
        else {
            secrettext.setText("")
        }
    }

    onPlainTextChanged: {
        timer.restart()
    }

    function updateValues() {
        updateGraph()
        calculateKasiski()
        if (secrettext.getSimpleText() === "") {
            root.sinkov = 0;
        }
        else {
            root.sinkov = Calculations.sinkovTest(secrettext.getSimpleText(), Globals.kd[language], Globals.kg)
        }
    }

    Timer {
        id: timer
        interval: 500;
        onTriggered: {
            updateValues()
        }
    }

    function updateGraph() {
        var text = secrettext.getSimpleText()
        graph.maxKeyLength = Math.min(text.replace(/ /g, "").length, 20)
        graph.initializeWithValues(Calculations.friedmanTest(text, 1, graph.maxKeyLength))
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
            ggt_text.text = qsTr("Kasiski Test: There are no repeating patterns in the entered text. Please add more plain text.")
        }
        else {
            var ggt = Vigenere.getGGTFromList(differences)
            ggt_text.text = qsTr("Kasiski Test: The GCD is %1 based on the following differences: %2").arg(ggt).arg(differences.join(", "))
        }
    }



    RowLayout {
        id: main
        spacing: 20
        anchors.top: parent.top
        height: parent.height/2
        width: parent.width

        Item {
            Layout.fillWidth: true
            height: 10
        }

        ColumnLayout {
            width: parent.width/2

            TeacherComponent {
                type: "Vigenere7Exercise"
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
                    //Layout.maximumWidth: 40

                    onTextChanged: {
                        exercise.key = key.text
                        secrettextUpdateFunction()
                        updateValues()
                    }
                }
            }
        }

        ColumnLayout {
            width: parent.width / 2
            spacing: 10

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

            TextArea {
                id: ggt_text
                readOnly: true
                Layout.fillWidth: true
                Layout.fillHeight: true
                wrapMode: TextEdit.Wrap

                style: TextAreaStyle {
                    backgroundColor: Globals.orange1
                    textColor: "black"

                }
            }

            TextArea {
                Layout.fillHeight: true
                Layout.fillWidth: true
                readOnly: true
                text: {
                    if (secrettext.getSimpleText().length === 0 || root.sinkov === 0) {
                        return "";
                    }

                    var tmp = qsTr("Sinkov Test = %1").arg(parseFloat(root.sinkov))
                    if (root.sinkov < 0.5) {
                        tmp += "\n" + qsTr("WARNING: sinkov < 0.5 is not valid, please add more text.")
                    }
                    return tmp
                }

                style: TextAreaStyle {
                    textColor: root.sinkov < 0.5 ? Globals.orange4 : "black"
                    backgroundColor: Globals.orange1
                }
            }
        }

        Item {
            Layout.fillWidth: true
            height: 10
        }
    }

    FriedmanGraph {
        id: graph
        anchors.topMargin: 5
        anchors.top: main.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
    }

    property var language: exercise.language
    onLanguageChanged: {
        graph.addLine(Globals.kd[language], "K_d")
        root.sinkov = Calculations.sinkovTest(secrettext.getSimpleText(), Globals.kd[language], Globals.kg)
        updateGraph()
    }

    Component.onCompleted: {
        var text = secrettext.getSimpleText()
        graph.maxKeyLength = Math.min(text.replace(/ /g, "").length, 20)
        graph.initializeWithValues(Calculations.friedmanTest(text, 1, graph.maxKeyLength))
        graph.addLine(Globals.kg, "K_g")

        calculateKasiski()
        updateGraph()
    }
}

