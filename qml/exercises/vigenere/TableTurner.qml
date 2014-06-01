import QtQuick 2.2
import QtQuick.Layouts 1.1

import "../../common"

GridLayout {
    columns: 3
    rows: 3

    rowSpacing: 0
    columnSpacing: 0

    property int gridWidth: 13
    property int gridHeight: 13

    ArrowButton {
        id: left
        Layout.fillHeight: true
        Layout.column: 0
        Layout.row: 1
        width: 30
        baseImage: "go-previous"

        enabled: table.fromX > 0

        onClicked: {
            table.fromX -= gridWidth
            table.selectedColumn = -1
        }
    }

    ArrowButton {
        id: right
        Layout.fillHeight: true
        Layout.column: 2
        Layout.row: 1
        width: 30
        baseImage: "go-next"

        enabled: table.toX < 25

        onClicked: {
            table.fromX += gridWidth
            table.selectedColumn = -1
        }
    }

    ArrowButton {
        id: top
        Layout.fillWidth: true
        Layout.column: 1
        Layout.row: 0
        height: 30
        baseImage: "go-up"

        enabled: table.fromY > 0

        onClicked: {
            table.fromY -= gridHeight
            table.selectedRow = -1
        }
    }

    ArrowButton {
        id: bottom
        Layout.fillWidth: true
        Layout.column: 1
        Layout.row: 2
        height: 30
        baseImage: "go-down"

        enabled: table.toY < 25

        onClicked: {
            table.fromY += gridHeight
            table.selectedRow = -1
        }
    }

    VigenereTable {
        id: table
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.column: 1
        Layout.row: 1

        fromX: 0
        toX: Math.min(table.fromX + gridWidth - 1, 25)

        fromY: 0
        toY: Math.min(table.fromY + gridHeight - 1, 25)
    }
}
