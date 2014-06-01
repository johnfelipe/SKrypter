import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common"
import "Caesar.js" as Caesar

Item {
    id: root
    property int key: key_field.number

    property var exercise

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter

            SKrypterText {
                id: key_text
                //: Encryption key
                //~ not key on keyboard or house key
                text: qsTr("cipherkey:")
            }

            NumberField {
                id: key_field
                minimum: 1
                maximum: 25
                text: exercise.studentKey !== 0 ? exercise.studentKey : Math.floor((Math.random()*25)+1)

                onNumberChanged: {
                    exercise.studentKey = number
                }
            }

            SKrypterButton {
                //: indicates that a key is randomly generated
                text: qsTr("random")

                onClicked: {
                    key_field.text = Math.floor((Math.random()*25)+1);
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            Wheel {
                id: wheel
                anchors.fill: parent
                anchors.horizontalCenter: parent.horizontalCenter
                key: root.key
                draggingChangesKey: false
            }
        }

        SKrypterButton {
            text: qsTr("check")
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            enabled: root.key != 0

            onClicked: {
                var isCorrect = Caesar.check(plaintext.getSimpleText(), secrettext.getSimpleText(), root.key, true)
                if (isCorrect) {
                    finalResult(isCorrect)
                }
                else {
                    intermediateResult(isCorrect);
                }

                secrettext.setText(Caesar.markText(plaintext.getSimpleText(), secrettext.getSimpleText(), root.key, true))
            }
        }
    }

    //student save/load/print handling

    property string cipherText: secrettext.getSimpleText()
    onCipherTextChanged: {
        exercise.studentCipherText = cipherText
    }

    Component.onCompleted: {
        secrettext.readOnly = false
    }
}
