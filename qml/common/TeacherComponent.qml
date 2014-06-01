import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1

import "../common"
import "Globals.js" as Globals

/**
  * This component contains all gui elements and functionality
  * that is common to all teacher qml files
  */

ColumnLayout {
    id: root

    property var updateFunction

    property string type

    property string secretText: secrettext.getSimpleText()
    onSecretTextChanged: {
        exercise.cipherText = secretText
    }

    property string plainText: plaintext.getSimpleText()
    onPlainTextChanged: {
        exercise.plainText = plainText
        if (updateFunction) {
            updateFunction()
        }
    }

    spacing: 10

    Row {
        spacing: 10

        SKrypterText {
            text: qsTr("Title:")
            anchors.baseline: title.baseline
            // NOTE: This is a bug: https://bugreports.qt-project.org/browse/QTBUG-36529
        }

        SKrypterTextField {
            id: title

            text: exercise.title
            onTextChanged: {
                exercise.title = text
            }

            verticalAlignment: TextInput.AlignVCenter
        }

        SKrypterText {
            visible: exercise.filename
            text: exercise.filename ? qsTr("Filename: %1").arg(exercise.getRelativePath(exercise.filename)) : ""
            anchors.baseline: title.baseline
        }
    }

    Row {
        spacing: 10

        SKrypterText {
            text: qsTr("Language:")
            anchors.baseline: language.baseline
        }

        ComboBox {
            id: language
            width: 60

            model: Globals.language_list

            onActivated: {
                exercise.language = textAt(index)
            }

            Component.onCompleted: {
                // Setting it directly does not seem to work for some reason...
                currentIndex = find(exercise.language)
            }
        }

        SKrypterButton {
            text: qsTr("Edit Help")
            onClicked: {
                loadNewScreen("/qml/common/TeacherHelpEditor.qml", model)
            }
        }
    }

    Row {
        spacing: 10

        SKrypterText {
            text: qsTr("Keep:")
        }

        CheckBox {
            id: is_case_checkbox

            text: qsTr("Lower case")

            // Workaround, property binding to checkboxes seems to be buggy
            property var exIsCase: exercise.isCase
            onExIsCaseChanged: {
                checked = exIsCase
            }

            onCheckedChanged: {
                exercise.isCase = checked
                if (updateFunction) {
                    updateFunction()
                }
            }
        }

        CheckBox {
            id: is_blanks_checkbox

            text: qsTr("Blanks")

            // Workaround, property binding to checkboxes seems to be buggy
            property var exIsBlanks: exercise.isBlanks
            onExIsBlanksChanged: {
                checked = exIsBlanks
            }

            onCheckedChanged: {
                exercise.isBlanks = checked
                if (updateFunction) {
                    updateFunction()
                }
            }
        }
    }

    Component.onCompleted: {
        plaintext.readOnly = false
    }
}
