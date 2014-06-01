import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common"
import "Caesar.js" as Caesar
import "../alphabet.js" as Alphabet
import "../../common/Globals.js" as Globals

Item {
    id: root

    property var exercise

    property bool init: true

    Item {
        id: podium_rectangle
        height: parent.height/2
        width: parent.width

        Item {
            id: frequent_letters_row
            width: podium.width
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter

            Row {
                id: letter_row
                spacing: podium.width/5
                anchors.horizontalCenter: parent.horizontalCenter

                function letterUpdate() {
                    if (!root.init) {
                        var letters = ""
                        letters += most_frequent_letter.text === "" ? "_" : most_frequent_letter.text
                        letters += second_most_frequent_letter.text === "" ? "_" : second_most_frequent_letter.text
                        letters += third_most_frequent_letter.text === "" ? "_" : third_most_frequent_letter.text
                        exercise.studentLetters = letters
                        console.log("Saving " + letters)
                    }
                }

                LetterField {
                    id: second_most_frequent_letter
                    anchors.top: parent.verticalCenter
                    font.pixelSize: 24
                    height: font.pixelSize*1.5

                    onTextChanged: letter_row.letterUpdate()

                    KeyNavigation.tab: third_most_frequent_letter
                }

                LetterField {
                    id: most_frequent_letter
                    anchors.top: parent.top
                    font.pixelSize: 24
                    height: font.pixelSize*1.5
                    focus: true

                    onTextChanged: letter_row.letterUpdate()

                    KeyNavigation.tab: second_most_frequent_letter
                }

                LetterField {
                    id: third_most_frequent_letter
                    anchors.top: parent.bottom
                    font.pixelSize: 24
                    height: font.pixelSize*1.5

                    onTextChanged: letter_row.letterUpdate()
                }
            }
        }

        Item {
            id: correct_location
            anchors.left: frequent_letters_row.right
            anchors.right: parent.right
            height: parent.height
        }

        Image {
            id: podium
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            source: "/images/caesar/podium.svg"
            sourceSize.width: parent.width
            sourceSize.height: parent.height*4/5
            fillMode: Image.PreserveAspectFit
        }

        SKrypterButton {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            enabled: most_frequent_letter.text.length && second_most_frequent_letter.text.length && third_most_frequent_letter.text.length
            //: Check whether the result is correct
            text: qsTr("check")

            onClicked: {
                var userResult = most_frequent_letter.text + second_most_frequent_letter.text + third_most_frequent_letter.text
                var isCorrect = Caesar.checkFrequency(secrettext.getSimpleText(), userResult)

                if (isCorrect) {
                    finalResult(true, correct_location)
                    switch_view.start()
                }
                else {
                    intermediateResult(false, correct_location)
                }
            }
        }
    }

    Column {
        id: counter
        width: parent.width
        anchors.top: podium_rectangle.bottom
        anchors.margins: 10

        spacing: 10

        ListModel {
            id: letter_model

            Component.onCompleted: {
                for (var i = 0; i < Globals.alphabet_length; i++) {
                    var letter = Alphabet.indexToUpperString(i);
                    letter_model.append({"letter":letter, "counter": exercise.hiddenCounter.length === Globals.alphabet_length ? exercise.hiddenCounter[i] : 0});
                }
            }
        }

        LetterCounter {
            id: letter_counter
            width: parent.width
            usedModel: letter_model

            onCounterChanged: {
                //update stored counter
                var counter = []
                for (var i=0; i< usedModel.count; i++) {
                    counter[i] = usedModel.get(i).counter
                }
                exercise.hiddenCounter = counter

            }
        }

        SKrypterButton {
            id: reset_counter_button
            anchors.right: parent.right
            text: qsTr("reset counters")

            onClicked: {
                letter_counter.resetCounters = true
            }
        }
    }

    Column {
        id: frequency_item
        opacity: 0
        visible: opacity !==0
        width: parent.width
        anchors.top: podium_rectangle.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 10
        spacing: 10

        ListModel {
            id: language_frequency_model
        }

        ListModel {
            id: text_frequency_model
        }

        FrequencyLetters {
            id: dyn_statistik
            usedModel: text_frequency_model
            borderColor: Globals.pink3
            outerHeight: (frequency_item.height- frequency_item.spacing)*45/100
        }

        FrequencyLetters {
            id: statistik
            usedModel: language_frequency_model
            languageFlag: exercise.language
            outerHeight: (frequency_item.height- frequency_item.spacing)*45/100
        }
    }

    ParallelAnimation {
        id: switch_view

        NumberAnimation {
            target: frequency_item;
            property: "opacity";
            to: 1.0;
            duration: 600
        }

        NumberAnimation {
            target: counter;
            property: "opacity";
            to: 0;
            duration: 600
        }
    }

    Component.onCompleted: {
        Alphabet.createOrUpdateAlphabet(language_frequency_model, false, exercise.language)
        Alphabet.createOrUpdateAlphabet(text_frequency_model, true, exercise.language)
        Alphabet.updateStats(secrettext.getSimpleText(), text_frequency_model, true)
        Alphabet.sortModel(text_frequency_model, false)
        Alphabet.sortModel(language_frequency_model, false)
        most_frequent_letter.forceActiveFocus()

        if (exercise.studentLetters !== "") {
            most_frequent_letter.text = exercise.studentLetters[0] === "_" ? "" : exercise.studentLetters[0]
            second_most_frequent_letter.text = exercise.studentLetters[1] === "_" ? "" : exercise.studentLetters[1]
            third_most_frequent_letter.text = exercise.studentLetters[2] === "_" ? "" : exercise.studentLetters[2]
        }

        root.init = false
    }
}
