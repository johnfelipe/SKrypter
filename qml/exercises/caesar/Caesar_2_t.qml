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

    property int key: (plain_letter.text !== "" && cipher_letter.text !== "") ?
                          Caesar.getKeyFromLetters(plain_letter.text, cipher_letter.text) : -1

    function secrettextUpdateFunction() {
        if (key !== -1) {
            secrettext.setText(Alphabet.cleanText(
                                   Caesar.crypt(plaintext.getSimpleText(), key, true),
                                   exercise.isCase, exercise.isBlanks ? " " : "", exercise.language))
        }
        else {
            secrettext.setText("")
        }
    }

    onKeyChanged: {
        secrettextUpdateFunction()
    }

    ColumnLayout {
        anchors.centerIn: parent

        TeacherComponent {
            id: teacher_comp
            width: parent.width
            type: "Caesar2Exercise"
            updateFunction: secrettextUpdateFunction
        }

        GridLayout {
            columns: 2


            SKrypterText {
                text: qsTr("Ciphertext letter:")
                anchors.baseline: cipher_letter.baseline
            }

            LetterField {
                id: cipher_letter
                text: exercise.cipherLetter
                verticalAlignment: TextInput.AlignVCenter
                Layout.maximumWidth: 40
                borderColor: Globals.pink2

                onTextChanged: {
                    exercise.cipherLetter = text
                }
            }

            SKrypterText {
                text: qsTr("Plaintext letter:")
                anchors.baseline: plain_letter.baseline
            }

            LetterField {
                id: plain_letter
                text: exercise.plainLetter
                verticalAlignment: TextInput.AlignVCenter
                Layout.maximumWidth: 40
                borderColor: Globals.blue2

                onTextChanged: {
                    exercise.plainLetter = text
                }
            }
        }
    }
}

