import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common/"
import "../../common/Globals.js" as Globals
import "../alphabet.js" as Alphabet
import "Caesar.js" as Caesar

Item {
    id: root

    property var exercise

    function secrettextUpdateFunction() {
        if (exercise.key !== "") {
            secrettext.setText(Alphabet.cleanText(
                                   Caesar.crypt(plaintext.getSimpleText(), exercise.key, true),
                                   exercise.isCase, exercise.isBlanks ? " " : "", exercise.language))
        }
    }

    ColumnLayout {
        anchors.centerIn: parent

        TeacherComponent {
            type: "Caesar3Exercise"
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
                text: exercise.key

                verticalAlignment: TextInput.AlignVCenter
                Layout.maximumWidth: 40

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
                }
            }
        }
    }
}

