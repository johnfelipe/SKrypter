import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "../../common"
import "../alphabet.js" as Alphabet
import "Caesar.js" as Caesar
import "../../common/Globals.js" as Globals


ColumnLayout {
    id: root
    spacing: 10
    anchors.fill: parent

    property var exercise

    property bool isKeyCorrect: false
    property bool isTaskCorrect: false

    property int correctKey: Caesar.getKeyFromLetters(exercise.plainLetter, exercise.cipherLetter)

    Item {
        id: letters
        Layout.fillHeight: true
        anchors.left: parent.left
        anchors.right: parent.right

        Rectangle {
            id: cipher_letter_rectangle
            width: key_text_cipher.font.pixelSize
            height: key_text_cipher.font.pixelSize * 1.2
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            color: Globals.pink3
            SKrypterText {
                id: key_text_cipher
                anchors.centerIn: parent
                property string cipherletter: exercise.cipherLetter
                text: cipherletter
                font.pixelSize: 180
                font.bold: true
            }
        }

        SKrypterText {
            text: qsTr("codes")
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            font.pixelSize: 64
            font.bold: true
        }

        Rectangle {
            width: key_text_plain.font.pixelSize
            height: key_text_plain.font.pixelSize * 1.2
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            color: Globals.blue3

            SKrypterText {
                id: key_text_plain
                anchors.centerIn: parent
                property string plainletter: exercise.plainLetter
                text: plainletter
                font.pixelSize: 180
                font.bold: true
            }
        }

        Wheel {
            id: wheel
            opacity: 0
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            draggingChangesKey: false
            key: 0
            showNeedle: false

            onOpacityChanged: {
                if (opacity === 1) {
                    key = key_field.number
                }
                if (opacity === 0) {
                    key = 0
                }
            }

            Image {
                source: root.isKeyCorrect ? "/images/caesar/arrow_green.svg" : "/images/caesar/arrow_orange.svg"
                anchors.centerIn: parent
                width: parent.width
                height: parent.height*2/3
                fillMode: Image.PreserveAspectFit
                sourceSize.height: height
                sourceSize.width: width
                rotation: Alphabet.charCodeToIndex(key_text_plain.plainletter.charCodeAt(0)) * (360/26)
            }
        }

        Image {
            //this image is used both for indicating whether the key is correct
            id: correct_image
            width: wheel.width*2/3
            height: wheel.height*2/3
            anchors.centerIn: wheel
            opacity: 0
            source: isKeyCorrect ? "/images/correct.svg" : "/images/false.svg"
            sourceSize.height: height/2
            sourceSize.width: width/2
            fillMode: Image.PreserveAspectFit
        }

        SequentialAnimation {
            id: animate_opacity_wheel

            //show wheel
            NumberAnimation {
                target: wheel;
                property: "opacity";
                to: 1.0;
                duration: 200
            }

            //wait for wheel to turn (if opacity hits 1 the key is set in onOpacityChanged method of wheel)
            PauseAnimation { duration: 4000 }

            //show correct or wrong sign
            NumberAnimation {
                target: correct_image;
                property: "opacity";
                to: 1.0;
                duration: 600
            }

            //wait
            PauseAnimation { duration: 2000 }

            //fade wheel and sign
            ParallelAnimation {
                NumberAnimation {
                    target: wheel;
                    property: "opacity";
                    to: 0.0;
                    duration: 600
                }

                NumberAnimation {
                    target: correct_image;
                    property: "opacity";
                    to: 0.0;
                    duration: 600
                }
            }

            ScriptAction {
                script: if(root.isKeyCorrect) letter_show_animation.start();
            }
        }
    }


    RowLayout {
        id: letter_mapper
        opacity: 0

        Layout.fillHeight: true
        anchors.left: parent.left
        anchors.right: parent.right

        Repeater{
            model: Globals.alphabet_length

            delegate:
                ColumnLayout {
                spacing: 5

                Rectangle {
                    color: "transparent"
                    border.color: "black"
                    border.width: 1
                    radius: 3

                    height: 40

                    Layout.fillWidth: true

                    SKrypterText {
                        anchors.centerIn: parent
                        text: Alphabet.indexToUpperString(index)
                    }
                }

                Rectangle {
                    color: "transparent"
                    border.color: "black"
                    border.width: 1
                    radius: 3

                    height: 40

                    Layout.fillWidth: true

                    SKrypterText {
                        anchors.centerIn: parent
                        text: index
                    }
                }
            }
        }
    }

    NumberAnimation {
        id: letter_show_animation
        target: letter_mapper;
        property: "opacity";
        to: 1.0;
        duration: 600
    }

    Item {
        anchors.left: parent.left
        anchors.right: parent.right
        height: 30

        RowLayout {
            anchors.fill: parent
            spacing: 10

            Label {
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("Cipherkey")
            }

            NumberField {
                id: key_field
                anchors.verticalCenter: parent.verticalCenter
                enabled: !root.isKeyCorrect
                focus: true
                minimum: 0
                maximum: 25

                onNumberChanged: {
                    exercise.studentKey = key_field.number
                }
            }

            Item {
                //increases spacing
                width: 20
                height: parent.height
            }

            SKrypterButton {
                anchors.verticalCenter: parent.verticalCenter
                //: Check whether entered key is correct
                enabled: key_field.text !== "" && !root.isKeyCorrect
                text: qsTr("check key")
                onClicked: {
                    root.isKeyCorrect = (key_field.number === root.correctKey)

                    animate_opacity_wheel.start()
                }
            }

            Item {
                //increases spacing
                Layout.fillWidth: true
            }

            SKrypterButton {
                anchors.verticalCenter: parent.verticalCenter
                //: Check whether the entered plaintext is correct
                text: qsTr("check plaintext")
                enabled: root.isKeyCorrect
                onClicked: {
                    root.isTaskCorrect = Caesar.check(plaintext.getSimpleText(), secrettext.getSimpleText(), key_field.number, false)
                    if (root.isTaskCorrect) {
                        finalResult(root.isTaskCorrect)
                    }
                    else {
                        intermediateResult(root.isTaskCorrect);
                    }

                    plaintext.setText(Caesar.markText(plaintext.getSimpleText(), secrettext.getSimpleText(), key_field.number, false))
                }

            }
        }
    }

    property string plainText: plaintext.getSimpleText()
    onPlainTextChanged: {
        exercise.studentPlainText = plainText
    }

    Component.onCompleted: {
        plaintext.readOnly = false
        if (exercise.studentKey) {
            key_field.text = exercise.studentKey
            root.isKeyCorrect = (key_field.number === Caesar.getKeyFromLetters(exercise.plainLetter, exercise.cipherLetter))
            if (root.isKeyCorrect) {
                letter_mapper.opacity = 1.0
            }
        }
    }
}
