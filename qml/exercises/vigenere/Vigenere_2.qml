import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common"
import "Vigenere.js" as Vigenere
import "../alphabet.js" as Alphabet
import "../../common/Globals.js" as Globals

Item {
    id: root
    anchors.fill: parent

    property var exercise

    property int maximumKeyLength: Math.max (20, correctKey.length)

    property string wrongKey: exercise.wrongKey
    property string correctKey: exercise.key
    property string lineText: ""

    property string cipherText: secrettext.getSimpleText()

    onCipherTextChanged: {
        if (cipherText !== "") {
            var line = ""
            for (var i=0; i<cipherText.length; i++) {
                line +="-"
            }
            lineText = line
        }
    }

    Column {
        id: algo_col
        spacing: 10

        anchors.left: parent.left

        height: root.height
        width: root.width*3/7

        SKrypterText {
            text: qsTr("Key to check: %1").arg(root.wrongKey)
            font.pixelSize: 16
            font.bold: true
        }

        //increase spacing
        Item {
            height: 30
            width: 10
        }

        Rectangle {
            width: parent.width
            height: text_column.height + 25 + 10 //height of column plus height of scrollbar + margins
            border.color: "black"
            border.width: 2
            color: Globals.gray1

            ScrollView {
                anchors.fill: parent
                anchors.margins: 5

                Item {
                    width: plaintext_view.width
                    height: text_column.height

                    Column {
                        id: text_column
                        spacing: 5


                        MonospaceText {
                            id: plaintext_view
                            text: " " + plaintext.getSimpleText()
                        }

                        MonospaceText {
                            id: key_view
                            text: "+" + Vigenere.createKeyText(root.wrongKey, plaintext.getSimpleText())
                        }

                        MonospaceText {
                            id: line
                            text: " " + root.lineText
                        }

                        MonospaceText {
                            id: ciphertext_view
                            text: " " + secrettext.getSimpleText()
                        }

                    }
                }
            }
        }

        Row {
            spacing: 5

            SKrypterText {
                text: qsTr("corrected key:")
            }

            CleanTextField {
                id: userKey
                maximumLength: root.maximumKeyLength

                onTextChanged: {
                    text = Alphabet.cleanText(text, false, "", exercise.language)
                    exercise.studentCorrectedKey = text
                }

            }
        }

        SKrypterButton {
            text: qsTr("update key")
            enabled: userKey.text !== ""

            onClicked: {
                key_view.text = "+" + Vigenere.createKeyText(userKey.text, plaintext.getSimpleText())
            }
        }
    }
    SKrypterButton {
        text: qsTr("check")
        anchors.right: algo_col.right
        anchors.bottom: parent.bottom
        enabled: userKey.text !== ""

        onClicked: {
            var isCorrect = Vigenere.check(plaintext.getSimpleText(), secrettext.getSimpleText(), userKey.text, true)
            if (isCorrect) {
                finalResult(isCorrect)
            }
            else {
                intermediateResult(isCorrect);
            }
        }
    }

    TableTurner {
        anchors.left: algo_col.right
        anchors.leftMargin: 10

        height: root.height
        width: root.width*4/7
    }

    Component.onCompleted: {
        if (exercise.studentCorrectedKey !== "") {
            userKey.text = exercise.studentCorrectedKey
            key_view.text = "+" + Vigenere.createKeyText(userKey.text, plaintext.getSimpleText())
        }
    }
}
