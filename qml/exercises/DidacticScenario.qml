import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "alphabet.js" as Alphabet
import "../common"
import "../common/Globals.js" as Globals


/**
 * This class is the base for ALL didactic scenarios in the program. It contains the elements
 * needed for all didactic scenarios (namely plain and ciphertext areas) and additionally
 * contains a loader that will dynamically load the desired concrete didactic scenario.
 */
Column {
    id: root

    property var exercise

    anchors.fill: parent
    anchors.margins: 5
    spacing: 5

    property bool isCase: main_loader.teacherMode || exercise.isCase
    property bool isBlanks: main_loader.teacherMode || exercise.isBlanks

    Rectangle {
        id: secret_text
        height: (parent.height-parent.spacing*2)/5
        width: parent.width
        color: Globals.pink3
        radius: 5.0

        Label {
            id: secrettext_label
            //:Label for the ciphertext
            text: qsTr("Ciphertext")
            color: "black"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 5
        }

        SKrypterTextArea {
            id: secrettext
            anchors.top: secrettext_label.bottom

            text: {
                if (exercise.cipherText && (main_loader.teacher_mode || exercise.showCipherText)) {
                    return exercise.cipherText
                }
                if (!main_loader.teacherMode && exercise.studentCipherText) {
                    return exercise.studentCipherText
                }
                return ""
            }

            isCase: root.isCase
            isBlanks: root.isBlanks

            onSelectedTextChanged: {
                if (plaintext.selectionStart !== selectionStart || plaintext.selectionEnd != selectionEnd) {
                    plaintext.select(selectionStart, selectionEnd)
                }
            }
        }
    }

    Loader {
        id: didactic_loader
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5
        height: (parent.height-parent.spacing*2)*3/5

        //can be used by loaded components to display feedback (x or tick)
        function intermediateResult(correct, correctLocation) {
            if (correctLocation) {
                correct_image.parent = correctLocation
            }
            correct_image.isCorrect = correct
            animate_opacity_intermediate.start()
            if (correct) {
                exercise.studentSKrypterCheck = qsTr("This is a temporary solution which is not yet correct.")
            }
            else {
                exercise.studentSKrypterCheck = qsTr("This is a temporary solution which is correct.")
            }
        }

        //can be used by loaded components to display final feedback (x or tick)
        function finalResult(correct, correctLocation) {
            if (correctLocation) {
                correct_image.parent = correctLocation
            }
            correct_image.isCorrect = correct
            animate_opacity_final.start()
            didactic_loader.enabled = false
            plaintext.readOnly = true
            secrettext.readOnly = true
            if (correct) {
                exercise.studentSKrypterCheck = qsTr("This exercise has been checked by SKrypter and is correct.")
            }
            else {
                exercise.studentSKrypterCheck = qsTr("This exercise has been checked by SKrypter and is not correct.")
            }
        }

        //image that is used to give user feedback for the current exercise
        Image {
            id: correct_image
            anchors.fill: parent

            // Set by functions above
            property bool isCorrect: false

            // Has to be above loaded content
            z: 1

            // Initially hidden (only shown in animations)
            opacity: 0

            source:  isCorrect ? "/images/correct.svg" : "/images/false.svg"
            sourceSize.height: height/2
            sourceSize.width: width/2
            fillMode: Image.PreserveAspectFit

            NumberAnimation {
                id: animate_opacity_final
                target: correct_image;
                property: "opacity";
                to: 1.0;
                duration: 600
            }

            SequentialAnimation {
                id: animate_opacity_intermediate
                NumberAnimation {
                    target: correct_image;
                    property: "opacity";
                    to: 1.0;
                    duration: 600
                }

                PauseAnimation { duration: 1000 }

                NumberAnimation {
                    target: correct_image;
                    property: "opacity";
                    to: 0.0;
                    duration: 600
                }
            }
        }
    }

    Rectangle {
        id: plain_text
        height: (parent.height-parent.spacing*2)/5
        width: parent.width
        color: Globals.blue3
        radius: 5.0

        Label {
            id: plaintext_label
            //:Label for the plaintext
            text: qsTr("Plaintext")
            color: "black"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 5
        }

        SKrypterTextArea {
            id: plaintext
            anchors.top: plaintext_label.bottom

            text: {
                if (exercise.plainText && main_loader.teacherMode || exercise.showPlainText) {
                    return exercise.plainText
                }
                if (!main_loader.teacherMode && exercise.studentPlainText) {
                    return exercise.studentPlainText
                }
                return ""
            }

            isCase: root.isCase
            isBlanks: root.isBlanks
            language: exercise.language

            onSelectedTextChanged: {
                if (secrettext.selectionStart != selectionStart || secrettext.selectionEnd != selectionEnd) {
                    secrettext.select(plaintext.selectionStart, plaintext.selectionEnd)
                }
            }
        }
    }

    Component.onCompleted: {
        didactic_loader.setSource(main_loader.teacherMode ? model.qmlFile.replace(".qml", "_t.qml") : model.qmlFile, {"exercise": root.exercise })
    }
}


