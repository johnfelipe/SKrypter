import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

import "Globals.js" as Globals

Button {
    style: ButtonStyle {
        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 25
            border.width: control.activeFocus ? 2 : 1
            border.color: Globals.blue4
            radius: 6

            gradient: Gradient {
                GradientStop {position: 1 ; color: control.pressed ? Globals.blue0 : Globals.blue2 }
                GradientStop {position: 0.4 ; color: Globals.blue1 }
                GradientStop {position: 0 ; color: control.pressed ? Globals.blue2 : Globals.blue0 }
            }

        }
    }
}
