import QtQuick 2.2
import QtQuick.Controls 1.1

import "../common/"
import "../common/Globals.js" as Globals

import ExerciseLoader 1.0

/**
 * This class creates the individual cryptosystem menu.
 */
Item {
    id: root
    anchors.fill: parent

    property string cryptosys: ""

    property alias exerciseModel: page_turner.menu_list

    property int globalPixelSize: 18

    SKrypterText {
        id: title
        text: root.cryptosys
        anchors.horizontalCenter: parent.horizontalCenter
        font {
            capitalization: Font.SmallCaps
            bold: true
            pixelSize: 30
            letterSpacing: 2
        }
    }

    PageTurner {
        id: page_turner
        width: parent.width

        anchors.top: title.bottom
        anchors.bottom: parent.bottom

        delegate: Item {
            width: 180
            height: 210

            SKrypterButton {
                id: exercise_button
                width: (model.title === "Dummy") ? 0 : 180
                height: (model.title === "Dummy") ? 0 : 180
                anchors.top: parent.top

                Image {
                    anchors.fill: parent
                    source: model.picture
                    fillMode: Image.PreserveAspectCrop

                    Rectangle {
                        anchors.fill: parent
                        color: Globals.orange4
                        opacity: 0.3
                        visible: !main_loader.teacherMode && model.title !== "Dummy" && !ExerciseLoader.getList(model.type).hasValidExercises()

                        MouseArea {
                            anchors.fill: parent
                        }
                    }
                }

                onClicked: {
                    loadNewScreen("/qml/exercises/DidacticScenario.qml", ExerciseLoader.getList(model.type))
                }
            }

            SKrypterText {
                width: exercise_button.width
                //wrapMode: Text.WordWrap

                anchors {
                    top: exercise_button.bottom
                    bottom: parent.bottom
                    margins: 5
                    horizontalCenter: parent.horizontalCenter
                }
                font {
                    bold: true
                    pixelSize: root.globalPixelSize
                    letterSpacing: 2
                }
                // Make sure the title is not longer than 22 characters or the font
                // will get too small
                text: (model.title === "Dummy") ? "" : model.title.substring(0, 22)

                onContentWidthChanged: {
                    while (contentWidth > width) {
                        font.pixelSize--
                        root.globalPixelSize--
                    }
                }
            }
        }
    }

}

