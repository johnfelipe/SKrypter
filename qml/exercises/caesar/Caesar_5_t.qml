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

    property string language: exercise.language

    onLanguageChanged: {
        Alphabet.createOrUpdateAlphabet(language_frequency_model, false, language)
    }

    function secrettextUpdateFunction() {
        if (exercise.key !== "" && text_frequency_model.count > 0) {
            secrettext.setText(Alphabet.cleanText(Caesar.crypt(plaintext.getSimpleText(), exercise.key, true),
                                                   exercise.isCase, exercise.isBlanks ? " " : "", exercise.language))
            timer.restart()
        }
    }

    Timer {
        id: timer
        interval: 500;
        onTriggered: {
            Alphabet.updateStats(secrettext.getSimpleText(), text_frequency_model, true)
        }
    }

    ColumnLayout {
        id: base
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        TeacherComponent {
            type: "Caesar5Exercise"
            updateFunction: secrettextUpdateFunction
        }

        Row {
            spacing: 10

            SKrypterText {
                text: qsTr("Key:")
                anchors.baseline: key.baseline
            }

            NumberField {
                id: key
                minimum: 1
                maximum: 25
                verticalAlignment: TextInput.AlignVCenter
                Layout.maximumWidth: 40
                text: exercise.key

                onTextChanged: {
                    var keyNum
                    if (key.text === "") {
                        keyNum = 0
                    }
                    else {
                        keyNum = parseInt(key.text)
                    }
                    exercise.key = keyNum

                    secrettextUpdateFunction()

                    if (key.text !== "" && text_frequency_model.count > 0) {
                        Alphabet.shiftModelToLetter(text_frequency_model, parseInt(key.text))
                    }
                }
            }
        }
    }

    Column {
        id: frequency_item
        anchors.top: base.bottom
        anchors.bottom: parent.bottom
        anchors.topMargin: 10
        width: parent.width
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


    Component.onCompleted: {
        Alphabet.createOrUpdateAlphabet(language_frequency_model, false, exercise.language)
        Alphabet.createOrUpdateAlphabet(text_frequency_model, true, exercise.language)
        Alphabet.updateStats(secrettext.getSimpleText(), text_frequency_model, true)
        Alphabet.shiftModelToLetter(text_frequency_model, exercise.key)
    }
}

