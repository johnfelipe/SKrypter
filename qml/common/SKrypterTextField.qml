import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

TextField {
    property string borderColor: "black"

    style: TextFieldStyle {
        textColor: "black"
        background: Rectangle {
            id: rect
            radius: 2
            implicitWidth: 100
            implicitHeight: 30
            border.color: borderColor
            border.width: borderColor === "black" ? 1 : 3
        }
    }
}
