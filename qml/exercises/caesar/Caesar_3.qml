import QtQuick 2.2
import QtQuick.Controls 1.1

import "../../common"
import "Caesar.js" as Caesar

Item {
    anchors.fill: parent

    property var exercise

    Wheel {
        id: wheel
        anchors.fill: parent
        key: exercise.studentKey
        draggingChangesKey: true

        property int correctKey: exercise.key

        onKeyChanged: {
            if (key === correctKey) {
                draggingChangesKey = false
                finalResult(true)
            }

            plaintext.setText(Caesar.crypt(secrettext.getSimpleText(), key, false))

            exercise.studentKey = key
            exercise.studentPlainText = plaintext.getSimpleText()
        }
    }

    Component.onCompleted: {
        plaintext.setText(Caesar.crypt(secrettext.getSimpleText(), wheel.key, false))
    }
}
