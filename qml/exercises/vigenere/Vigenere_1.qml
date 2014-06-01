import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common"
import "Vigenere.js" as Vigenere
import "../../common/Globals.js" as Globals

Item {
    id: root

    property var exercise

    property string key: exercise.key

    property string cipherText: secrettext.getSimpleText()
    onCipherTextChanged: {
        exercise.studentCipherText = cipherText
    }

    Item {
        id: algo_item

        anchors.left: parent.left

        height: root.height
        width: root.width*3/7

        SKrypterText {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Key: %1").arg(root.key)
            font.pixelSize: 16
            font.bold: true
        }

        Rectangle {
            width: parent.width
            height: text_column.height + 25 + 10 //height of column plus height of scrollbar + margins
            anchors.verticalCenter: parent.verticalCenter
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
                            text: plaintext.getSimpleText()
                        }

                        MonospaceText {
                            id: key_view
                            text: Vigenere.createKeyText(root.key, plaintext.getSimpleText())
                        }
                    }

                }
            }
        }

        SKrypterButton {
            text: qsTr("check")
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            onClicked: {
                var isCorrect = Vigenere.check(plaintext.getSimpleText(), secrettext.getSimpleText(), root.key, true)
                if (isCorrect) {
                    finalResult(isCorrect)
                }
                else {
                    intermediateResult(isCorrect);
                }

                secrettext.setText(Vigenere.markText(plaintext.getSimpleText(), secrettext.getSimpleText(), root.key, true))
            }
        }
    }

    TableTurner {
        anchors.left: algo_item.right

        height: root.height
        width: root.width*4/7
    }

    Component.onCompleted: {
        secrettext.readOnly = false
    }
}
