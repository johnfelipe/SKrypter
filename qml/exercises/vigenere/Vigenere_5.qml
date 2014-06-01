import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import CCode 1.0
import "../../common"
import "Vigenere.js" as Vigenere
import "../../common/Globals.js" as Globals

Item {
    id: root
    anchors.fill: parent

    property var exercise

    property var friedmanNumbers

    property int maxKeyLength
    property int keyLenghtSolution: exercise.key.length

    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        ColumnLayout {
            width: parent.width
            spacing: 5

            SKrypterText {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("key length slider")
            }

            RowLayout {
                width: parent.width

                Item{
                    width: 30
                    SKrypterText {
                        anchors.centerIn: parent
                        font.pixelSize: 20
                        text: key_slider.value
                    }
                }

                Slider {
                    id: key_slider
                    Layout.fillWidth: true
                    tickmarksEnabled: true
                    minimumValue: 1
                    maximumValue: Math.max(1, root.maxKeyLength)
                    stepSize: 1
                    updateValueWhileDragging: false

                    onValueChanged: {
                        if (graph && root.maxKeyLength) {
                            var text = secrettext.getSimpleText()
                            text = text.replace(new RegExp("(([a-z] ?){1," + value + "})(([a-z] ?){0," + value + "})", "ig"), "<font color='#1ca938'><i><b>$1</i></b></font><font color='black'><i><b>$3</i></b></font>")
                            secrettext.setText(text)

                            graph.updateDataPoint(value, friedmanNumbers[value-1])
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            FriedmanGraph {
                id: graph
                anchors.fill: parent
            }
        }

        Row {
            spacing: 20

            SKrypterText {
                text: qsTr("key length")
            }

            NumberField {
                id: user_solution
                minimum: 1
                maximum: maxKeyLength

                onNumberChanged: {
                    exercise.studentKeyLength = number
                }
            }

            SKrypterButton {
                enabled: user_solution.text !== ""
                text: qsTr("check")
                onClicked: {
                    if (parseInt(user_solution.text) === root.keyLenghtSolution) {
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
        text: qsTr("You have successfully completed the task. If you want you can continue and try to decrypt the cipher text now that you have found the correct key length. \n Do you want to try?")
        okFunction: function() {
            // Want to load directly vigenere cont, but only if in student mode!
            if (!_view.isTeacherProgram()) {
                exercise.qmlFile = "vigenere/Vigenere_cont.qml"
            }

            var newModel = {}
            newModel.qmlFile = "vigenere/Vigenere_cont.qml"
            newModel.helpTitle = qsTr("Vigenere: Extra Task")
            newModel.helpText = qsTr("Take into account that the key length is correct.")
            var newExercises = []
            exercise.studentKeyLength = root.keyLenghtSolution
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
        var text = secrettext.getSimpleText()
        root.maxKeyLength = Math.min(text.length, 20)
        graph.maxKeyLength = Math.min(text.replace(/ /g, "").length, root.maxKeyLength)
        friedmanNumbers = Calculations.friedmanTest(text, 1, graph.maxKeyLength)
        graph.initialize(root.maxKeyLength)

        graph.addLine(Globals.kg, "K_g")

        graph.addLine(Globals.kd[exercise.language], "K_d")

        if (exercise.studentKeyLength !== -1) {
            user_solution.text = exercise.studentKeyLength
        }
    }
}
