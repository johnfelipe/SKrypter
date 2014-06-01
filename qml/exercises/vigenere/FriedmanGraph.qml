import QtQuick 2.2

import "../../common"

Rectangle {
    id: graph
    anchors.leftMargin: 30
    anchors.bottomMargin: 26
    border.color: "black"
    border.width: 3
    radius: 10

    property real upperY: 0

    property int dotWidth: 10
    property int maxKeyLength

    property int currentLength

    ListModel {
        id: dataPointModel
    }

    ListModel {
        id: linesModel
    }

    Repeater {
        model: dataPointModel

        Item {
            anchors.fill: graph
            property int xPos: ((index + 0.5) * graph.width / graph.maxKeyLength) - (graph.dotWidth / 2)

            Rectangle {
                id: dot
                x: parent.xPos
                y: graph.height -(model.y / (graph.upperY * 1.1) * graph.height) - (graph.dotWidth / 2)
                visible: model.y !== 0
                color: "black"
                width: graph.dotWidth
                height: graph.dotWidth
                radius: graph.dotWidth

            }

            SKrypterText {
                width: graph.dotWidth
                anchors.top: parent.bottom
                x: parent.xPos
                text: index+1
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Repeater {
        model: linesModel

        Item {
            anchors.fill: parent

            SKrypterText {
                id: line_label
                anchors.right: parent.left
                anchors.rightMargin: 5
                text: model.text
                height: graph.dotWidth
                verticalAlignment: Text.AlignVCenter
                y:graph.height - (model.y / (graph.upperY * 1.1) * graph.height) - (graph.dotWidth / 2)
            }

            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: graph.width - 2*graph.border.width
                color: "green"
                height: 2
                y:graph.height -(model.y / (graph.upperY * 1.1) * graph.height) - (graph.dotWidth / 2)
            }


        }
    }

    function updateDataPoint(x, y) {
        if (y > upperY) {
            upperY = y
        }

        dataPointModel.get(x-1).y = y
    }

    function addLine(y, text) {
        if (y > upperY) {
            upperY = y
        }
        // Replace old value, if label already exists
        for (var i=0; i<linesModel.count; i++) {
            if (linesModel.get(i).text === text) {
                linesModel.remove(i)
                break
            }
        }

        linesModel.append({y: y, text: text})
    }

    function initialize(length) {
        for (var i=1; i<=length; i++) {
            dataPointModel.append({y: 0})
        }
        graph.currentLength = length
    }

    function initializeWithValues(values) {
        upperY = 0
        if (values.length !== graph.currentLength) {
            dataPointModel.clear()
            graph.currentLength = values.length
            initialize(graph.currentLength)
        }

        for (var i=1; i<=values.length; i++) {
            graph.updateDataPoint(i, values[i-1])
        }


    }

}
