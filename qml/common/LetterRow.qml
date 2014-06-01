import QtQuick 2.2
import QtQuick.Layouts 1.1

import "../exercises/caesar/Caesar.js" as Caesar
import "../exercises/alphabet.js" as Alphabet

import "Globals.js" as Globals

Rectangle {
    id: root

    property alias usedModel: buchstaben_repeater.model

    //height of the outer rectangle
    property int outerHeight: 0

    //indicates the color that the borders around the letters should have
    property string borderColor: "black"

    property int currentKey: 0

    property bool isPercent: true

    function setCurrentKey(key) {
        root.currentKey = key
        Alphabet.shiftModelToLetter(root.usedModel, key)
    }

    anchors.left: parent.left
    anchors.right: parent.right
    height: outerHeight
    color: (main_loader.teacherMode ? Globals.orange1 : Globals.gray1)

    Rectangle {
        id: innerRectangle
        width: parent.width
        height: parent.height
        color: parent.color

        property real letterWidth: (buchstaben.width - buchstaben.spacing*(Globals.alphabet_length-1))/Globals.alphabet_length
        property real totalWidth: letterWidth + buchstaben.spacing

        RowLayout {
            anchors.fill: parent

            ColumnLayout {
                anchors.top: parent.top
                anchors.topMargin: 2
                visible: !root.onlyPureLetters

                Image {
                    source: "/images/flags/cipher.svg"
                    sourceSize.width: 40
                    fillMode: Image.PreserveAspectFit
                }

                SKrypterText {
                    text: "%"
                    font.pixelSize: 20
                    visible: isPercent
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                Row {
                    id: buchstaben
                    spacing: 5
                    width: parent.width
                    height: parent.height

                    NumberAnimation {
                        id: animate_row
                        duration: 300
                        target: buchstaben
                        to: 0
                        property: "x"
                    }

                    Repeater {
                        id: buchstaben_repeater

                        Rectangle {
                            id: buchstaben_rectangle
                            width: innerRectangle.letterWidth
                            height: root.height
                            border.color: (main_loader.teacherMode ? Globals.orange1 : Globals.gray1)
                            border.width: 4
                            //                    property int totalWidth: width + buchstaben.spacing
                            color: root.color

                            Behavior on x{
                                NumberAnimation {
                                    duration: 250
                                }
                            }

                            Column {
                                id: buchstaben_column
                                anchors.fill: parent
                                anchors.margins: 2
                                spacing: 2

                                Rectangle {
                                    width: parent.width
                                    height: (buchstaben_rectangle.height -buchstaben_column.spacing)*1/3
                                    color: "white"
                                    border.color: root.borderColor
                                    radius: 2
                                    SKrypterText {
                                        anchors.centerIn: parent
                                        text: model.letter
                                    }
                                }

                                Rectangle {
                                    id: percent_base_rect
                                    width: parent.width
                                    height: (buchstaben_rectangle.height -buchstaben_column.spacing)*2/3
                                    color: root.color

                                    SKrypterText {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.top: parent.top
                                        text: Math.round(model.percentage * 10) / 10
                                        font.pixelSize: 10
                                        color: "black"
                                    }

                                    Rectangle {
                                        id: percent_rect
                                        anchors.bottom: parent.bottom
                                        anchors.topMargin: 12
                                        width: parent.width/2
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        color: Globals.gray3
                                        height: Alphabet.percentageToHeight(buchstaben_repeater.model, index, percent_base_rect.height - percent_rect.anchors.topMargin)
                                    }
                                }
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    drag {
                        target: buchstaben
                        axis: Drag.XAxis
                        minimumX: -buchstaben.width + innerRectangle.letterWidth
                        maximumX: buchstaben.width - innerRectangle.letterWidth
                    }

                    onReleased: {
                        var positionsMoved = Math.floor((buchstaben.x +(innerRectangle.totalWidth/2))/(innerRectangle.totalWidth))
                        root.currentKey = (buchstaben_repeater.count + root.currentKey - positionsMoved) % buchstaben_repeater.count
                        Alphabet.shiftModel(root.usedModel, positionsMoved)

                        animate_row.from = buchstaben.x - positionsMoved * (innerRectangle.totalWidth)
                        animate_row.start()
                    }
                }
            }
        }
    }
}
