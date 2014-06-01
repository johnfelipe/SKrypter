import QtQuick 2.2
import QtQuick.Layouts 1.1

import "Vigenere.js" as Vigenere
import "../alphabet.js" as Alphabet
import "../../common"
import "../../common/Globals.js" as Globals

Item {
    id:root
    property int fromX: 0
    property int toX: 25
    property int fromY: 0
    property int toY: 25

    //currently selected row and column
    property int selectedColumn: -1
    property int selectedRow: -1

    GridLayout {
        id: layout
        anchors.fill: parent
        rows: toX - fromX + 2
        columns: toY - fromY + 2

        rowSpacing: 0
        columnSpacing: 0



        Repeater {
            model: layout.rows * layout.columns

            Rectangle {
                property int column: index%layout.rows
                property int row: index/layout.rows

                property bool isMarked: (row === root.selectedRow) || (column === root.selectedColumn)

                Layout.fillWidth: true
                Layout.fillHeight: true
                color: isMarked ? Globals.green3 : (column === 0 || row === 0 ? "white" : Globals.gray1)
                border.color: Globals.gray4
                border.width: column === 0 || row === 0  ? 1 : 0

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        //set currently active row and column
                        if (column === 0) {
                            root.selectedRow = row
                        }
                        else if (row === 0) {
                            root.selectedColumn = column
                        }
                        else {
                            root.selectedColumn = column
                            root.selectedRow = row
                        }
                    }
                }

                SKrypterText {
                    anchors.fill: parent
                    color: "black"
                    text: column == 0 && row == 0 ? "" : (column == 0 ? Alphabet.indexToUpperString(row - 1 + root.fromY) : (row == 0 ? Alphabet.indexToUpperString(column - 1 + root.fromX) : Alphabet.indexToUpperString((row + column - 2 + root.fromX + root.fromY)%Globals.alphabet_length)))
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
}
