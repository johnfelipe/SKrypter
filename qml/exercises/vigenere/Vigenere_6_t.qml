import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common"
import "Vigenere.js" as Vigenere
import "../alphabet.js" as Alphabet
import "../../common/Globals.js" as Globals
import CCode 1.0

Item {
    id: root

    property var exercise

    property real sinkov

    onSinkovChanged: {
        exercise.sinkov = root.sinkov
    }

    function secrettextUpdateFunction() {
        if (key.text === "") {
            root.sinkov = 0;
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

        triggeredOnStart: true

        onTriggered: {
            triggeredOnStart = false

            if (secrettext.getSimpleText() === "" || key.text === "") {
                root.sinkov = 0;
            }
            else {
                root.sinkov = Calculations.sinkovTest(secrettext.getSimpleText(), Globals.kd[language], Globals.kg)
            }
        }
    }

    ColumnLayout {
        anchors.centerIn: parent

        TeacherComponent {
            type: "Vigenere6Exercise"
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
                //Layout.maximumWidth: 40

                onTextChanged: {
                    exercise.key = key.text
                    secrettextUpdateFunction()
                }
            }
        }

        SKrypterText {
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
            color: root.sinkov < 0.5 ? Globals.orange4 : "black"
        }
    }

    property var language: exercise.language
    onLanguageChanged: {
        root.sinkov = Calculations.sinkovTest(secrettext.getSimpleText(), Globals.kd[exercise.language], Globals.kg)
    }

    Component.onCompleted: {
        key.text = exercise.key
    }
}

