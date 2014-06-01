import QtQuick 2.2
import QtQuick.Layouts 1.1

import "../../common"
import "../alphabet.js" as Alphabet
import "Perm.js" as Perm

Item {
    id: root

    property string language

    property int numberOfBigrams: 10
    property int bigramLength: 2
    property int numberOfTrigrams: 10
    property int trigramLength: 3

    property bool bigramsVisible: true
    property int flagWidth: 40
    property int arrowWidth: 40


    property string ignoreCharacters: isBlanks ? " " : ""

    Item {
        //Navigation to previous page! Can only navigate to previous page if a previous page exists!
        id: prev_rectangle
        width: root.arrowWidth
        height: parent.height
        anchors.left: parent.left

        property bool hasPrevPage: !root.bigramsVisible
        property bool isPressed: false

        Image {
            id: bigrams_image
            anchors.verticalCenter: parent.verticalCenter
            source: prev_rectangle.hasPrevPage ? (prev_rectangle.isPressed ? "/icons/go-previous_clicked.svg" : "/icons/go-previous.svg") : "/icons/go-previous_disabled.svg"
            sourceSize.width: parent.width
            fillMode: Image.PreserveAspectFit

            SKrypterText {
                anchors.centerIn: parent
                text: "Bi"
            }

            MouseArea {
                id: prev_mouse_area

                anchors.fill: parent

                onClicked: {
                    if (prev_rectangle.hasPrevPage) {
                        root.bigramsVisible = true
                        trigram_view.selectedXgram = ""
                    }
                }

                onPressed: {
                    prev_rectangle.isPressed = true
                }
                onReleased: {
                    prev_rectangle.isPressed = false
                }
            }
        }
    }

    Rectangle {
        id: switchable_rectangle
        anchors.left: prev_rectangle.right
        anchors.right: next_rectangle.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 2
        anchors.rightMargin: 2
        radius: 5.0
        border.color: "black"
        color: "transparent"
        border.width: 2

        Column {
            id: stat_column
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            XGramView {
                id: bigram_view
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height-parent.spacing*2
                visible: root.bigramsVisible

                xgramLength: root.bigramLength
                numberOfXgrams: root.numberOfBigrams
                text: secrettext.getSimpleText()

                language: root.language

                onSelectedXgramChanged: {
                    secrettext.text = Alphabet.markXGrams(secrettext.getSimpleText(), selectedXgram)
                }
            }

            XGramView {
                id: trigram_view
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height-parent.spacing*2

                visible: !root.bigramsVisible

                xgramLength: root.trigramLength
                numberOfXgrams: root.numberOfTrigrams
                text: secrettext.getSimpleText()

                language: root.language

                onSelectedXgramChanged: {
                    secrettext.text = Alphabet.markXGrams(secrettext.getSimpleText(), selectedXgram)
                }
            }
        }
    }

    Item {
        //Navigation to next page! Can only navigate to next page if a next page exists!
        id: next_rectangle
        height: parent.height
        anchors.right: parent.right
        width: root.arrowWidth

        property bool hasNextPage: root.bigramsVisible

        Image {
            id: trigram_next
            anchors.verticalCenter: parent.verticalCenter
            property bool isPressed: false
            source: next_rectangle.hasNextPage ? (trigram_next.isPressed ? "/icons/go-next_clicked.svg" : "/icons/go-next.svg") : "/icons/go-next_disabled.svg"
            sourceSize.width: parent.width
            fillMode: Image.PreserveAspectFit

            SKrypterText {
                anchors.centerIn: parent
                text: "Tri"
            }

            MouseArea {
                id: trigram_next_ma
                anchors.fill: parent
                onClicked: {
                    if (next_rectangle.hasNextPage) {
                        root.bigramsVisible = false
                        bigram_view.selectedXgram = ""
                    }
                }

                onPressed: {
                    trigram_next.isPressed = true
                }
                onReleased: {
                    trigram_next.isPressed = false
                }
            }
        }
    }

}
