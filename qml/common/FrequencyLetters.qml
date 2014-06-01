import QtQuick 2.2
import QtQuick.Layouts 1.1

import "../exercises/alphabet.js" as Alphabet
import "Globals.js" as Globals

Item {
    id: root

    property alias usedModel: buchstaben_repeater.model

    //indicates whether we display the statistics or not
    property bool onlyPureLetters: false

    property string languageFlag: "cipher"

    //indicates whether the letters can be switched or not
    property bool switchable: false

    //defines whether to show the gray bars
    property bool showBars: true

    //height of the outer rectangle
    property int outerHeight: 0

    //function called upon released if letters changed
    property var releaseFunction: function doNothing() {}

    //indicates the color that the borders around the letters should have
    property string borderColor: "black"

    property string markedLetter: ""

    property bool isPercent: true

    onMarkedLetterChanged: {
        markLetter(buchstaben_repeater, markedLetter)
    }

    function remarkLetters() {
        markLetter(buchstaben_repeater, markedLetter)
    }

    function markLetter(buchstaben_repeater, markedLetter) {
        Alphabet.unmarkAll(buchstaben_repeater)
        if (markedLetter.length === 1 && Alphabet.charCodeToIndex(markedLetter.charCodeAt(0)) !== -1) {
            Alphabet.markSelectedLetter(buchstaben_repeater.model, markedLetter, buchstaben_repeater)
        }
    }

    //private
    property int flagWidth: 40

    anchors.left: parent.left
    anchors.right: parent.right
    height: outerHeight

    property bool isDragging: false

    MouseArea {
        anchors.fill: parent
        cursorShape: isDragging ? Qt.ClosedHandCursor : Qt.ArrowCursor
    }

    RowLayout {
        id: row_layout
        anchors.fill: parent

        ColumnLayout {
            anchors.top: parent.top
            anchors.topMargin: 2
            visible: !root.onlyPureLetters
            Image {
                id: flag_image
                visible: (root.languageFlag.length > 0)
                source: (root.languageFlag.length > 0) ? ("/images/flags/" + root.languageFlag + ".svg") : ""
                sourceSize.width: root.flagWidth
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
                id: buchstaben_repeater

                Rectangle {
                    id: buchstaben_rectangle
                    width: (buchstaben.width - buchstaben.spacing*(Globals.alphabet_length-1))/Globals.alphabet_length
                    height: root.height
                    border.color: "transparent"
                    border.width: 4
                    property real totalWidth: width + buchstaben.spacing
                    color: "transparent"

                    property bool markedBorder: false

                    //workaround because somehow updates do not work directly (probably QML bug)
                    onMarkedBorderChanged: {
                        if (markedBorder) {
                            letter_rectangle.border.color = Globals.green4
                            letter_rectangle.border.width = 3
                        }
                        else  {
                            letter_rectangle.border.color =  root.borderColor
                            letter_rectangle.border.width = 1
                        }
                    }

                    Behavior on x{
                        enabled: !root.onlyPureLetters
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
                            id: letter_rectangle

                            width: parent.width
                            height: root.onlyPureLetters ? (buchstaben_rectangle.height) : (buchstaben_rectangle.height -buchstaben_column.spacing)*1/3
                            color: root.switchable ? "white" : (main_loader.teacherMode ? Globals.orange1 : Globals.gray1)
                            border.color: root.borderColor
                            border.width: 1

                            radius: 2
                            SKrypterText {
                                anchors.centerIn: parent
                                text: model.letter
                            }
                        }

                        Item {
                            id: percent_base_rect
                            visible: !root.onlyPureLetters
                            width: parent.width
                            height: (buchstaben_rectangle.height -buchstaben_column.spacing)*2/3

                            SKrypterText {
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top: parent.top
                                text: Math.round(model.percentage * 10) / 10
                                font.pixelSize: showBars ? 10 : 12
                                color: "black"
                            }

                            Rectangle {
                                id: percent_rect
                                anchors.bottom: parent.bottom
                                anchors.topMargin: 12
                                width: parent.width/2
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: Globals.gray3
                                visible: root.showBars
                                height: Alphabet.percentageToHeight(buchstaben_repeater.model, index, percent_base_rect.height - percent_rect.anchors.topMargin)
                            }
                        }
                    }

                    MouseArea{
                        id: drag_area
                        anchors.fill: parent
                        enabled: root.switchable
                        property int startPosition: 0
                        property int endPosition: startPosition
                        property int positionsMoved: Math.floor((endPosition - startPosition +(buchstaben_rectangle.totalWidth/2))/(buchstaben_rectangle.totalWidth))
                        property int newPosition: index + positionsMoved

                        cursorShape: switchable ? (root.isDragging ? Qt.ClosedHandCursor : Qt.OpenHandCursor) : Qt.ArrowCursor

                        drag {
                            target: buchstaben_rectangle
                            axis: Drag.XAxis
                            minimumX: 0
                            maximumX: buchstaben.width - buchstaben_rectangle.width
                        }

                        onPressed: {
                            root.isDragging = true
                            letter_rectangle.border.color = Globals.orange4
                            letter_rectangle.border.width = 2
                            buchstaben_rectangle.z=1
                            startPosition = buchstaben_rectangle.x
                        }

                        onPositionChanged: {
                            endPosition = buchstaben_rectangle.x
                        }

                        onReleased: {
                            root.isDragging = false
                            letter_rectangle.border.color = root.borderColor
                            letter_rectangle.border.width = 1
                            buchstaben_rectangle.z=0

                            if (Math.abs(positionsMoved) <1) {
                                buchstaben_rectangle.x = startPosition
                            }
                            else {
                                var myIndex = index
                                var myPosition = newPosition

                                if (myPosition < 1) {
                                    buchstaben_repeater.model.move(myIndex, 0, 1)
                                    //this line swaps the items instead of moving all items
                                    buchstaben_repeater.model.move(1, myIndex, 1)
                                }
                                else if (myPosition >= buchstaben_repeater.count -1) {
                                    buchstaben_repeater.model.move(myIndex, buchstaben_repeater.count -1, 1)
                                    //this line swaps the items instead of moving all items
                                    buchstaben_repeater.model.move(buchstaben_repeater.count -2, myIndex, 1)
                                }
                                else {
                                    buchstaben_repeater.model.move(myPosition, index, 1)
                                    buchstaben_repeater.model.move(index, myPosition, 1)
                                }
                                root.remarkLetters()

                                releaseFunction()
                            }
                        }
                    }
                }
            }
        }
    }
}
