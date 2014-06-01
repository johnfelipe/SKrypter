import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common"
import "Perm.js" as Perm
import "../alphabet.js" as Alphabet

import "../../common/Globals.js" as Globals

ColumnLayout {
    id: root

    property var exercise

    spacing: 10

    Item {
        //center vertically
        Layout.fillHeight: true
        width: parent.width
    }

    Column {
        id: key_view
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height/4
        spacing: 5

        ListModel {
            id: plain_model
        }

        ListModel {
            id: cipher_model
        }

        FrequencyLetters {
            id: dyn_statistik
            usedModel: cipher_model
            borderColor: Globals.pink3
            onlyPureLetters: true
            switchable: true
            outerHeight: (key_view.height - key_view.spacing)*50/100
            languageFlag: ""

            releaseFunction: function() {
                var key = Perm.readKeyFromModel(usedModel)
                if (key.length === Globals.alphabet_length) {
                    exercise.studentKey = key
                }
            }
        }

        FrequencyLetters {
            id: statistik
            usedModel: plain_model
            borderColor: Globals.blue3
            onlyPureLetters: true
            switchable: false
            outerHeight: (key_view.height - key_view.spacing)*50/100
            languageFlag: ""
        }

    }

    Item {
        //center vertically
        Layout.fillHeight: true
        width: parent.width
    }

    SKrypterButton {
        anchors.right: parent.right
        text: qsTr("check")


        onClicked: {
            var isCorrect = Perm.checkKey(cipher_model, plaintext.getSimpleText(), secrettext.getSimpleText())
            if (isCorrect) {
                finalResult(isCorrect)
            }
            else {
                intermediateResult(isCorrect);
            }

            secrettext.setText(Perm.markText(plaintext.getSimpleText(), secrettext.getSimpleText(), cipher_model, true))
        }
    }

    Component.onCompleted: {
        var studentKey = exercise.studentKey
        Alphabet.createOrUpdateAlphabet(plain_model, false, exercise.language)
        Alphabet.createOrUpdateAlphabet(cipher_model, false, exercise.language)

        if (studentKey !== "") {
            //set the model to the key
            Perm.setMapping(cipher_model, Perm.getMappingFromKey(studentKey))
        }
    }
}
