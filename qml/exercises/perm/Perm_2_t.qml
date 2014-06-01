import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common/"
import "../../common/Globals.js" as Globals
import "../alphabet.js" as Alphabet
import "Perm.js" as Perm

Item {
    id: root

    property var exercise

    property bool init: true

    property var mapping: Perm.getSimpleMapping(cipher_model)

    function secrettextUpdateFunction() {
        if (cipher_model.count > 0) {
            secrettext.setText(Alphabet.cleanText(Perm.crypt(plaintext.getSimpleText(), Perm.getSimpleMapping(cipher_model)),
                                                   exercise.isCase, exercise.isBlanks ? " " : "", exercise.language))
            var key = Perm.getKeyFromMapping(Perm.getSimpleMapping(cipher_model))
            exercise.key = key
        }
    }

    onMappingChanged: {
        //necessary to avoid function call upon initializing cipher_model
        if (!init) {
            secrettextUpdateFunction()
        }
    }


    property string key: exercise.key

    ColumnLayout {
        anchors.fill: parent
        spacing: 10


        TeacherComponent {
            id: base
            anchors.horizontalCenter: parent.horizontalCenter
            type: "Perm2Exercise"
            updateFunction: secrettextUpdateFunction
        }

        Column {
            id: key_view
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height/4
            spacing: 5

            ListModel {
                id: cipher_model
            }

            ListModel {
                id: plain_model
            }

            FrequencyLetters {
                id: dyn_statistik
                usedModel: cipher_model
                borderColor: Globals.pink3
                onlyPureLetters: true
                switchable: true
                outerHeight: (key_view.height - key_view.spacing)*50/100
                languageFlag: ""

                releaseFunction: secrettextUpdateFunction
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

        SKrypterButton {
            id: button
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("generate random key")

            onClicked: {
                Alphabet.sortModelRandomly(cipher_model)
            }

        }

    }

    Component.onCompleted: {
        Alphabet.createOrUpdateAlphabet(cipher_model, false, exercise.language)
        Alphabet.createOrUpdateAlphabet(plain_model, false, exercise.language)

        if (exercise.key !== "") {
            var mapping = Perm.getMappingFromKey(exercise.key)
            Perm.setMapping(cipher_model, mapping)
        }

        root.init = false
    }
}
