import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import "PageTurner.js" as PageTurner

/**
 * This class creates an interactive page turner. The page turner has a model
 * which contains the elements to be displayed. It creates as many pages as
 * are needed. The pages can be navigated similar to reading a book on an e-reader.
 * The underlying QML Component is a GridView. Some of the default GridView behaviour
 * had to be adapted to get a functioning PageTurner.
 */
Item {
    id: page_turner
    anchors.margins: 5

    //this is the base model that never gets modified
    property var menu_list

    property alias delegate: menu_grid_view.delegate

    Item {
        //Navigation to previous page! Can only navigate to previous page if a previous page exists!
        id: prev_rectangle
        width: 50
        height: parent.height
        anchors.left: parent.left

        property bool hasPrevPage: (menu_grid_view.lowestDisplayedItem > 0)
        property bool isPressed: false

        Image {
            id: previous_image
            anchors.verticalCenter: parent.verticalCenter
            source: prev_rectangle.hasPrevPage ? (prev_rectangle.isPressed ? "/icons/go-previous_clicked.svg" : "/icons/go-previous.svg") : "/icons/go-previous_disabled.svg"

            MouseArea {
                id: prev_mouse_area

                anchors.fill: parent

                onClicked: {
                    if (prev_rectangle.hasPrevPage) {
                        menu_grid_view.lowestDisplayedItem -= menu_grid_view.totalElementsVisible
                        //make sure that the lowestDisplayedItem is never below zero (this can happen with above code)
                        if (menu_grid_view.lowestDisplayedItem < 0) {
                            menu_grid_view.lowestDisplayedItem = 0
                        }

                        //reset the grid view
                        menu_grid_view.positionViewAtIndex(menu_grid_view.lowestDisplayedItem, GridView.Beginning)
                    }
                }

                onPressed: {
                    prev_rectangle.isPressed = true
                }
                onReleased: {
                    prev_rectangle.isPressed = false
                }
            }
        }
    }

    Item {
        id: main_menu_rectangle
        anchors.left: prev_rectangle.right
        anchors.right: next_rectangle.left
        anchors.top: parent.top
        anchors.bottom: pages_rectangle.top

        GridView {
            id: menu_grid_view
            interactive: false

            ListModel {
                //use the model with dummies here, because otherwise display is not correct!
                id: modelWithDummies
            }

            model: PageTurner.getModelWithDummies(page_turner.menu_list, modelWithDummies, neededDummies)

            cellWidth: 200;
            cellHeight: 230

            //indicates how many columns could be created based on available space
            property int elementsPerWidth: Math.min(Math.floor(main_menu_rectangle.width/cellWidth), page_turner.menu_list.length)

            //indicates how many rows could be created based on available space
            property int elementsPerHeight: Math.min(Math.floor(main_menu_rectangle.height/cellHeight), page_turner.menu_list.length)

            //this is all elements that are currently visible, either this is how many elements fit, or how many elements there are
            property int totalElementsVisible: Math.min(elementsPerWidth*elementsPerHeight, page_turner.menu_list.length)

            //the number of elements INCLUDING dummy elements
            property int totalElements: model.count

            //the number of dummies needed to get a correct display (e.g. 4 elements are visible, there are 5 elements, we need 3 dummies so that the 5th element is correctly displayed)
            property int neededDummies: page_turner.menu_list.length % totalElementsVisible == 0 ? 0 : totalElementsVisible - (page_turner.menu_list.length % totalElementsVisible)

            //this is the index that is needed to correctly set the position of the gridView
            property int lowestDisplayedItem: 0

            //the actual width and height that we need to display the elements (so that we can nicely display them)
            property int newWidth: elementsPerWidth * cellWidth
            property int newHeight: (totalElementsVisible < totalElements) ? elementsPerHeight * cellHeight : (Math.ceil(totalElements/elementsPerWidth) * cellHeight)


            anchors.centerIn: parent
            anchors.margins: 5
            height: newHeight
            width: newWidth

            flow: GridView.LeftToRight
            snapMode: GridView.SnapOneRow
            clip: true

            onTotalElementsVisibleChanged: {
                //if the user changes the window size the grid view RESETS to 0 to avoid issues!
                menu_grid_view.lowestDisplayedItem = 0
                menu_grid_view.positionViewAtIndex(0, GridView.Beginning)
            }
        }
    }

    Item {
        //used to indicate on which page the user currently is
        id: pages_rectangle
        anchors.left: prev_rectangle.right
        anchors.right: next_rectangle.left
        height: 50
        anchors.bottom: parent.bottom

        property int currentPage: menu_grid_view.lowestDisplayedItem/menu_grid_view.totalElementsVisible + 1
        property int totalPages: menu_grid_view.model.count / menu_grid_view.totalElementsVisible

        SKrypterText {
            anchors.centerIn: parent
            font {
                pixelSize: 16
            }
            text: qsTr("Page %1 of %2").arg(pages_rectangle.currentPage).arg(pages_rectangle.totalPages)
        }
    }


    Item {
        //Navigation to next page! Can only navigate to next page if a next page exists!
        id: next_rectangle
        height: parent.height
        anchors.right: parent.right
        width: 50

        property bool hasNextPage: (menu_grid_view.lowestDisplayedItem < (menu_list.length - menu_grid_view.totalElementsVisible))

        property bool isPressed: false

        Image {
            id: next_image
            anchors.verticalCenter: parent.verticalCenter
            source: next_rectangle.hasNextPage ? (next_rectangle.isPressed ? "/icons/go-next_clicked.svg" : "/icons/go-next.svg") : "/icons/go-next_disabled.svg"

            MouseArea {
                id: next_mouse_area
                anchors.fill: parent
                onClicked: {
                    if (next_rectangle.hasNextPage) {
                        menu_grid_view.lowestDisplayedItem += menu_grid_view.totalElementsVisible
                        if (menu_grid_view.lowestDisplayedItem > menu_grid_view.totalElements - menu_grid_view.totalElementsVisible) {
                            menu_grid_view.lowestDisplayedItem = menu_grid_view.totalElements - menu_grid_view.totalElementsVisible
                        }
                        menu_grid_view.positionViewAtIndex(menu_grid_view.lowestDisplayedItem, GridView.Beginning)
                    }
                }

                onPressed: {
                    next_rectangle.isPressed = true
                }
                onReleased: {
                    next_rectangle.isPressed = false
                }
            }
        }

    }
}
