import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common"
import "Vigenere.js" as Vigenere
import "../alphabet.js" as Alphabet
import CCode 1.0

Item {
    id: root

    property var exercise

    property real fc

    function secrettextUpdateFunction() {
        if (key.text === "") {
            secrettext.setText("")
            root.fc = 1
        }
        else {
            secrettext.setText(Alphabet.cleanText(Vigenere.crypt(plaintext.getSimpleText(), key.text, true),
                               exercise.isCase, exercise.isBlanks ? " " : "", exercise.language))
            root.fc = Math.round(Calculations.calculateFC(secrettext.getSimpleText())*10000)/10000
        }
    }

    ColumnLayout {
        anchors.centerIn: parent

        TeacherComponent {
            type: "Vigenere4Exercise"
            updateFunction: secrettextUpdateFunction
        }

        GroupBox {
            width: parent.width
            height: 40

            Row {
                SKrypterText {
                    text: qsTr("Frequencies should be: ")
                }

                ExclusiveGroup {
                    id: ra_group
                }

                RadioButton {
                    id: relative
                    text: qsTr("relative")
                    checked: exercise.isRelative
                    exclusiveGroup: ra_group
                    width: 100

                    onCheckedChanged: {
                        exercise.isRelative = checked
                    }
                }
                RadioButton {
                    id: absolute
                    text: qsTr("absolute")
                    checked: !exercise.isRelative
                    exclusiveGroup: ra_group
                }
            }
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
            text: qsTr("FC(ciphertext) = %1").arg(parseFloat(root.fc))
        }

    }

    Component.onCompleted: {
        root.fc = Math.round(Calculations.calculateFC(secrettext.getSimpleText())*10000)/10000

        key.text = exercise.key
    }
}

