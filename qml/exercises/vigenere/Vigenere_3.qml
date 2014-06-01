import QtQuick 2.2

import "../../common"
import "Vigenere.js" as Vigenere
import "../alphabet.js" as Alphabet
import CCode 1.0

Item {
    id: root

    property var exercise

    property int correctAnswer: -1

    ListModel {
        id: trigram_model
    }

    ListModel {
        id: quadgram_model
    }

    ListModel {
        id: quintgram_model
    }

    Column {
        id: column
        anchors.fill: parent
        spacing: 10

        XGramFrequencies {
            id: quintgrams
            showBars: false
            clickable: true
            outerHeight: (column.height - 3*column.spacing)*25/100
            visible: usedModel.count > 0

            onSelectedXgramChanged: {
                secrettext.text = Alphabet.markXGrams(secrettext.getSimpleText(), selectedXgram)
            }
        }

        XGramFrequencies {
            id: quadgrams
            showBars: false
            clickable: true
            outerHeight: (column.height - 3*column.spacing)*25/100
            visible: usedModel.count > 0

            onSelectedXgramChanged: {
                secrettext.text = Alphabet.markXGrams(secrettext.getSimpleText(), selectedXgram)
            }
        }

        XGramFrequencies {
            id: trigrams
            showBars: false
            clickable: true
            outerHeight: (column.height - 3*column.spacing)*25/100
            visible: usedModel.count > 0

            onSelectedXgramChanged: {
                secrettext.text = Alphabet.markXGrams(secrettext.getSimpleText(), selectedXgram)
            }
        }

        SKrypterText {
            text: {
                var tmp = qsTr("Position of marked text: ")
                if (secrettext.selectionStart === secrettext.selectionEnd) {
                    tmp += qsTr("No selection")
                }
                else {
                    tmp += Vigenere.getPositionWithoutBlanks(secrettext.getSimpleText(), secrettext.selectionStart)
                }
                return tmp
            }
        }

        Row {
            spacing: 10

            SKrypterText {
                text: qsTr("gcd:")
            }

            NumberField {
                id: user_ggT
                minimum: 0
                maximum: 9999

                onNumberChanged: {
                    exercise.studentGCD = number
                }
            }

            SKrypterButton {
                text :qsTr("Check")
                enabled: user_ggT.text !== ""

                onClicked: {
                    if (parseInt(user_ggT.text) === root.correctAnswer) {
                        intermediateResult(true)
                        message_box.visible = true
                    }
                    else {
                        intermediateResult(false);
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
        text: qsTr("You have successfully completed the task. If you want you can continue and try to verify the calculated key length. \n Do you want to try?")
        okFunction: function() {
            // Want to load directly vigenere cont, but only if in student mode!
            if (!_view.isTeacherProgram()) {
                exercise.qmlFile = "vigenere/Vigenere_cont.qml"
            }

            var newModel = {}
            newModel.qmlFile = "vigenere/Vigenere_cont.qml"
            newModel.helpTitle = qsTr("Vigenere: Extra Task")
            newModel.helpText = qsTr("Take into account that you only calculated the gcd and not all possible key candidates.")
            var newExercises = []
            exercise.studentKeyLength = root.correctAnswer
            newExercises[0] = exercise
            newModel.exercises = newExercises
            main_loader.setCurrentExercise(0)
            main_loader.loadNewScreen("/qml/exercises/DidacticScenario.qml", newModel)
        }

        cancelFunction: function() {
            finalResult(true)
        }
    }

    Component.onCompleted: {
        //initializes all models excluding duplicates (if ABCDE is in the quintgrams ABCD will NOT be in the quadgrams)
        //after duplicates are removed the model is trimmed based on exercise.maxXGrams

        var list = Calculations.calculateKasiskiXGrams(secrettext.getSimpleText(), 3, 5, exercise.maxXGrams)

        //5-grams
        Alphabet.createXGramModel(quintgram_model, list[0])
        quintgrams.usedModel = quintgram_model

        //4-grams
        Alphabet.createXGramModel(quadgram_model, list[1])
        quadgrams.usedModel = quadgram_model

        //3-grams
        Alphabet.createXGramModel(trigram_model, list[2])
        trigrams.usedModel = trigram_model

        var text = secrettext.getSimpleText()

        //calculate the correct answer
        var differences = []
        for (var i=0; i<list.length; i++) {
            for (var j=0; j<list[i].length; j+=2) {
                var positions = Vigenere.getPositions(text, list[i][j])
                differences = differences.concat(Vigenere.getDifferences(positions))
            }
        }

        if (differences.length > 0) {
            var ggt = Vigenere.getGGTFromList(differences)
            root.correctAnswer = ggt
            console.log("The program calculated the GGT based on the differences: " + differences.join(",") + " as being " + ggt)

        }

        if (exercise.studentGCD !== -1) {
            user_ggT.text = exercise.studentGCD
        }
    }
}

