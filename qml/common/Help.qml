import QtQuick 2.2
import QtQuick.Controls 1.1

import "Globals.js" as Globals

Rectangle {
    border.color: Globals.gray3
    border.width: 2
    color: main_loader.teacherMode ? Globals.orange1 : Globals.gray1

    property alias title: title.text
    property alias text: text_area.text

    Column {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        SKrypterText {
            id: title
            width: parent.width
            wrapMode: TextEdit.Wrap
            color: Globals.blue4

            font {
                pixelSize: 18
                bold: true
            }
        }

        TextArea {
            id: text_area
            readOnly: true
            height: parent.height - title.height - parent.spacing
            width: parent.width
            textFormat: TextEdit.RichText
            wrapMode: TextEdit.Wrap

            font {
                pixelSize: 16
            }
        }
    }
}
