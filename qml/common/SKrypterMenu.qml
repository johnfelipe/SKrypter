import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "Globals.js" as Globals

Item {
    id: root
    width: flagOnly ? 50 : 140
    height: 40

    // Public
    property alias model: repeater.model
    property int selectedItem: 0

    // Private
    property bool isCollapsed: true
    property int radius: 5
    property int itemHeight: 30
    property int itemSpacing: 5

    property int animationDuration: 300

    property int maxNumItems: 10
    property int currentPage: 0

    property bool flagOnly: false

    property var changeFunction: function(index) {
        isCollapsed = !isCollapsed
        selectedItem = index
    }

    onModelChanged: {
        if (model === undefined || selectedItem >= model.count) {
            selectedItem = 0
        }
    }

    RowLayout {
        visible: !flagOnly

        y: {
            if (arrowDown.enabled) {
                (root.itemHeight+root.itemSpacing)*(maxNumItems) + root.itemSpacing
            }
            else {
                var rest = repeater.count%root.maxNumItems
                if (rest === 0) {
                    rest = 10
                }

                (root.itemHeight+root.itemSpacing)*rest + root.itemSpacing
            }
        }
        anchors.horizontalCenter: root.horizontalCenter
        opacity: root.isCollapsed ? 0 : 1

        Behavior on opacity {
            NumberAnimation {
                duration: root.animationDuration
                easing.type: Easing.InOutQuad
            }
        }

        ArrowButton {
            id: arrowUp
            width: 30
            height: 30
            baseImage: "go-up"
            enabled: root.currentPage > 0

            onClicked: {
                root.currentPage -= 1
            }
        }

        ArrowButton {
            id: arrowDown
            width: 30
            height: 30
            baseImage: "go-down"
            enabled: (root.currentPage+1)*root.maxNumItems < repeater.count

            onClicked: {
                root.currentPage += 1
            }
        }
    }

    Repeater {
        id: repeater

        delegate: Rectangle {
            anchors.left: root.left
            anchors.margins: 5

            property int collapsedWidth: root.width - 2*root.itemSpacing

            width: root.isCollapsed || root.flagOnly ? collapsedWidth : Math.max(collapsedWidth, label.width + 10 + flag_image.width + 5)
            height: root.itemHeight
            border.color:  area.containsMouse ? Globals.blue3 : "black"
            border.width: area.containsMouse ? 3 : 1
            color: selectedItem == index ? Globals.blue1 : "white"
            radius: root.radius
            clip: true

            visible: Math.floor(index / maxNumItems) === currentPage

            Behavior on width {
                NumberAnimation {
                    duration: root.animationDuration
                    easing.type: Easing.InOutQuad
                }
            }

            z: selectedItem == index ? 1 : 0
            y: (isCollapsed ? 0 : (height+root.itemSpacing)*(index%maxNumItems)) + root.itemSpacing

            Item {
                anchors.fill: parent
                anchors.margins: 5

                Image {
                    id: flag_image
                    width: 30
                    anchors.verticalCenter: parent.verticalCenter
                    source: "/images/flags/" + repeater.model[index].language + ".svg"
                    sourceSize.width: width
                    fillMode: Image.PreserveAspectFit
                }

                SKrypterText {
                    id: label
                    anchors.verticalCenter: parent.verticalCenter
                    visible: !root.flagOnly
                    anchors.left: flag_image.right
                    anchors.leftMargin: 5
                    text: flagOnly ? "" : repeater.model[index].title
                    font.pixelSize: 20
                }
            }

            Behavior on y {
                NumberAnimation {
                    duration: root.animationDuration
                    easing.type: Easing.InOutQuad
                }
            }

            MouseArea {
                id: area
                anchors.fill: parent
                hoverEnabled: true

                onClicked: {
                    changeFunction(index)
                }
            }
        }
    }
}
