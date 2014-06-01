import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common/"
import "../../common/Globals.js" as Globals
import "../alphabet.js" as Alphabet
import "Vigenere.js" as Vigenere

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
    }

    ColumnLayout {
        anchors.centerIn: parent

        TeacherComponent {
            type: "Vigenere1Exercise"
            updateFunction: secrettextUpdateFunction
        }

        Row {
            spacing: 10

            SKrypterText {
                text: qsTr("Correct key:")
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
                text: qsTr("Wrong Key:")
                anchors.baseline: wrong_key.baseline
            }

            CleanTextField {
                id: wrong_key

                verticalAlignment: TextInput.AlignVCenter

                onTextChanged: {
                    exercise.wrongKey = wrong_key.text
                }
            }
        }
    }

    Component.onCompleted: {
        key.text = exercise.key
        wrong_key.text = exercise.wrongKey
    }
}

