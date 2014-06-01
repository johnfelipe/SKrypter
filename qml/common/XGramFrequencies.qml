import QtQuick 2.2
import QtQuick.Layouts 1.1

import "../exercises/alphabet.js" as Alphabet
import "Globals.js" as Globals


Rectangle {
    id: root

    property alias usedModel: xgram_repeater.model

    //height of the outer rectangle
    property int outerHeight: 0

    //defines whether the individual rectangles are clickable
    property bool clickable: false

    property int widthFactor: 10 //this factor determines the width of individual letter rectangles

    //defines whether to show the gray bars
    property bool showBars: true

    //indicates the color that the borders around the letters should have
    property string borderColor: "black"

    property string languageFlag: ""

    property string selectedXgram: ""
    property bool isPercent: true

    anchors.left: parent.left
    anchors.right: parent.right
    height: outerHeight
    color: main_loader.teacherMode ? Globals.orange1 : Globals.gray1

    RowLayout {
        anchors.fill: parent

        ColumnLayout {
            anchors.top: parent.top
            anchors.topMargin: 2
            visible: !root.onlyPureLetters
            Image {
                id: flag_image
                source: (root.languageFlag.length > 0) ? ("/images/flags/" + root.languageFlag + ".svg") : "/images/flags/cipher.svg"
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

        Row {
            id: buchstaben
            spacing: 5
            Layout.fillHeight: true
            Layout.fillWidth: true

            Repeater {
                id: xgram_repeater

                Item {
                    id: buchstaben_rectangle
                    width: (buchstaben.width - buchstaben.spacing*(root.widthFactor-1))/root.widthFactor
                    height: root.height

                    property real totalWidth: width + buchstaben.spacing
                    property bool isPressed: false

                    Column {
                        id: buchstaben_column
                        anchors.fill: parent
                        anchors.margins: 2
                        spacing: 2

                        Rectangle {
                            width: parent.width
                            height: (buchstaben_rectangle.height -buchstaben_column.spacing)*1/3
                            color: root.clickable ? "white" : (main_loader.teacherMode ? Globals.orange1 : Globals.gray1)
                            border.color: buchstaben_rectangle.isPressed ? Globals.green4 : root.borderColor
                            radius: 2

                            SKrypterText {
                                anchors.fill: parent
                                anchors.margins: 2
                                text: model.xgram
                                fontSizeMode: Text.Fit
                                font.pixelSize: 20
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        Rectangle {
                            id: percent_base_rect
                            width: parent.width
                            height: (buchstaben_rectangle.height - buchstaben_column.spacing)*2/3
                            color: root.color

                            SKrypterText {
                                id: main_label
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top: parent.top
                                text: Math.round(model.percentage * 1000) / 1000
                                font.pixelSize: showBars ? 10 : 20
                                color: "black"
                            }

                            Rectangle {
                                id: percent_rect
                                visible: showBars
                                anchors.bottom: parent.bottom
                                anchors.topMargin: 12
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: parent.width/2
                                height: Alphabet.percentageToHeight(xgram_repeater.model, index, percent_base_rect.height - percent_rect.anchors.topMargin)
                                color: Globals.gray3
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: root.clickable

                        onClicked: {
                            // Need emit changed signal if we click two times for Vigenere 3
                            root.selectedXgram = ""
                            root.selectedXgram = model.xgram
                        }

                        onPressed: {
                            buchstaben_rectangle.isPressed = true
                        }

                        onReleased: {
                            buchstaben_rectangle.isPressed = false
                        }

                    }
                }
            }
        }
    }
}
