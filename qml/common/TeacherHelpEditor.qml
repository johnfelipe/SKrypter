import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

import "../common/Globals.js" as Globals

ColumnLayout {
    anchors.fill: parent
    anchors.margins: 5

    property var exercise


    RowLayout {
        Text {
            text: qsTr("Help text:")
        }

        Item {
            Layout.fillWidth: true
        }

        SKrypterButton {
            text: qsTr("default")
            onClicked: {
                exercise.helpTextTeacherEdit = ""
            }
        }
    }

    TextArea {
        id: normalText
        Layout.fillHeight: true
        Layout.fillWidth: true

        text: exercise.helpTextTeacherEdit !== "" ? exercise.helpTextTeacherEdit : exercise.helpText
        textFormat: TextEdit.PlainText
        onTextChanged: {
            if (text !== exercise.helpText) {
                exercise.helpTextTeacherEdit = text
            }
        }
    }

    Text {
        text: qsTr("Preview:")
    }

    TextArea {
        text: normalText.text
        Layout.fillHeight: true
        Layout.fillWidth: true
        readOnly: true

        textFormat: TextEdit.RichText

        style: TextAreaStyle {
            backgroundColor: Globals.gray1
        }
    }
}
