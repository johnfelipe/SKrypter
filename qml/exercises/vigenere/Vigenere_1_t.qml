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
                text: qsTr("Key:")
                anchors.baseline: key.baseline
            }

            CleanTextField {
                id: key

                verticalAlignment: TextInput.AlignVCenter
                //Layout.maximumWidth: 40

                onTextChanged: {
                    text = Alphabet.cleanText(text, false, "", exercise.language)
                    exercise.key = key.text
                    secrettextUpdateFunction()
                }
            }
        }
    }

    Component.onCompleted: {
        key.text = exercise.key
    }
}

