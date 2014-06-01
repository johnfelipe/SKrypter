import QtQuick 2.2

import "../../common"
import "Vigenere.js" as Vigenere
import "../alphabet.js" as Alphabet

import CCode 1.0

Column {
    id: root
    spacing: 10

    property var exercise

    property real solution: 0.0
    property bool isRelative: exercise.isRelative

    SKrypterText {
        width: parent.width
        text: qsTr("Calculate the FC using the information provided below. Round to 3 digits after the comma.")
        font {
            pixelSize: 16
        }
        wrapMode: TextEdit.Wrap
    }

    SKrypterText {
        id: number_of_letters
    }

    SKrypterText {
        text: isRelative ? qsTr("relative frequency:") : qsTr("absolute frequency")
    }

    ListModel {
        id: text_frequency_model
    }

    FrequencyLetters {
        id: text_frequency
        usedModel: text_frequency_model
        outerHeight: 100
        showBars: false
        languageFlag: ""
        isPercent: root.isRelative
    }

    Row {
        id: user_solution_row

        property real userSolution: parseInt(before_comma.text) + afterSolution

        onUserSolutionChanged: {
            if (userSolution) {
                exercise.studentFCSolution = userSolution
            }
        }

        property real afterSolution: parseInt(after_comma.text)/Math.pow(10, after_comma.text.length)

        NumberField {
            id: before_comma
            focus: true
            minimum: 0
            maximum: 1
        }

        SKrypterText {
            text: ","
            font {
                pixelSize: 16
                bold: true
            }
        }

        SKrypterTextField {
            id: after_comma

            property int minimum: 0
            property int maximum: 999
            property int number: (text !== "") ? parseInt(text) : 0

            onTextChanged: {
                var cleanedText = ""
                for (var i=0; i<text.length; i++) {
                    var charCode = text[i].charCodeAt(0)
                    //keeps all numbers, removes everything else
                    if (charCode >= 48 && charCode <= 57) {
                        cleanedText += String.fromCharCode(charCode);
                    }
                }

                if (cleanedText.length > 3) {
                    text = Math.round(parseInt(cleanedText) / Math.pow(10, cleanedText.length) * 1000)
                }
            }
        }
    }

    SKrypterButton {
        enabled: after_comma.text !== "" && before_comma.text !== ""
        text: qsTr("check")
        onClicked: {
            if (user_solution_row.userSolution === root.solution) {
                finalResult(true)
            }
            else {
                intermediateResult(false);
            }
        }
    }

    Component.onCompleted: {
        root.solution = Math.round(Calculations.calculateFC(secrettext.getSimpleText())*1000)/1000

        Alphabet.createOrUpdateAlphabet(text_frequency_model, true, exercise.language)
        Alphabet.updateStats(secrettext.getSimpleText(), text_frequency_model, exercise.isRelative)
        var pureText = secrettext.getSimpleText().replace(/ /gi, "")

        number_of_letters.text = qsTr("The ciphertext contains %1 letters.").arg(pureText.length)

        if (exercise.studentFCSolution !== 0.0) {
            var beforeComma = Math.floor(exercise.studentFCSolution)
            var afterComma = Math.round((exercise.studentFCSolution - beforeComma)*1000)

            before_comma.text = beforeComma
            after_comma.text = afterComma
        }
    }
}
