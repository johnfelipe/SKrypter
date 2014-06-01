import QtQuick 2.0

import "../../common"
import "../../common/Globals.js" as Globals
import "Caesar.js" as Caesar
import "../alphabet.js" as Alphabet

Row {
    id: buchstaben
    spacing: 5

    property real widthForLetters: (buchstaben.width - buchstaben.spacing*(Globals.alphabet_length-1))/Globals.alphabet_length
    property bool resetCounters: false

    property var usedModel
    signal counterChanged

    onResetCountersChanged: {
        if (resetCounters) {
            for (var i = 0; i < usedModel.count; i++) {
                usedModel.setProperty(i, "counter", 0)
            }
            resetCounters = false
            buchstaben.counterChanged()
        }
    }

    Repeater {
        id: buchstaben_repeater
        model: usedModel

        Column {
            spacing: 5

            Rectangle {
                id: buchstaben_rectangle
                width: buchstaben.widthForLetters
                height: width
                border.color: "black"
                border.width: 1
                radius: 3
                color: "transparent"

                SKrypterText {
                    anchors.centerIn: parent
                    text: model.letter
                }
            }

            SKrypterText {
                id: counter
                anchors.horizontalCenter: parent.horizontalCenter
                text: model.counter
            }

            Image {
                id: plus
                width: buchstaben.widthForLetters
                height: width
                source: plus_ma.pressed ? "/icons/button_clicked.svg" : "/icons/button_base.svg"
                sourceSize.width: width
                sourceSize.height: height

                SKrypterText {
                    anchors.centerIn: parent
                    text: "+"
                    font.pixelSize: plus.width - plus.width/10
                    font.bold: true
                }

                MouseArea {
                    id: plus_ma
                    anchors.fill: parent

                    onClicked: {
                        usedModel.setProperty(index, "counter", model.counter+1)
                        buchstaben.counterChanged()
                    }
                }

            }

            Image {
                id: minus
                width: buchstaben.widthForLetters
                height: width
                source: minus_ma.pressed ? "/icons/button_clicked.svg" : "/icons/button_base.svg"
                sourceSize.width: width
                sourceSize.height: height


                SKrypterText {
                    anchors.centerIn: parent
                    text: "-"
                    font.pixelSize: minus.width - minus.width/10
                    font.bold: true
                }

                MouseArea {
                    id: minus_ma
                    anchors.fill: parent

                    onClicked: {
                        usedModel.setProperty(index, "counter", model.counter-1)
                        if (model.counter < 0) {
                            usedModel.setProperty(index, "counter", 0)
                        }
                        buchstaben.counterChanged()
                    }
                }
            }
        }
    }
}
