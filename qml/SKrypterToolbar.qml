import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import "common"
import "common/Globals.js" as Globals

import ExerciseLoader 1.0

Rectangle {
    id: root
    color: Globals.gray3

    property alias exercise_chooser: exercise_chooser

    // Make menu appear on top
    z: 1

    states: [
        State {
            name: "startMenu";
        },
        State {
            name: "csMenu";
        },
        State {
            name: "scenario";
        },
        State {
            name: "about";
        }

    ]

    RowLayout {
        id: rowLayout
        spacing: 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 15
        anchors.rightMargin: 15

        ToolbarButton {
            id: back_button
            source: "/icons/go-back.svg"
            visible: root.state == "startMenu" ? false : true
            tooltip: qsTr("navigate to previous page")

            onClicked: {
                if (root.state === "scenario"
                        && _view.isTeacherProgram()
                        && (main_loader.source.toString().indexOf("TeacherHelpEditor.qml") === -1)
                        && main_loader.model.exercises[main_loader.currentExercise].hasChanged()) {
                    question_box.text = qsTr("You have not yet saved your current changes. Are you sure you want to continue?")
                    question_box.okFunction = function(){ main_loader.model.exercises[main_loader.currentExercise].reset(); main_loader.goBack() }
                    question_box.visible = true
                }
                else {
                    main_loader.goBack()
                }
                console.log("back button activated")
            }
        }

        ToolbarButton {
            id: teacher_button
            visible: _view.isTeacherProgram() && root.state != "about"
            enabled: main_loader.source.toString().indexOf("TeacherHelpEditor") === -1
            source: main_loader.teacherMode ? "/icons/teacher-mode_r.svg" : "/icons/teacher-mode.svg"
            tooltip: qsTr("switch between teacher and student view")

            onClicked: {
                if (root.state == "scenario" && main_loader.teacherMode && !main_loader.model.exercises[main_loader.currentExercise].isValid()) {
                    message_box.text = qsTr("You have not entered all required information for this exercise. Please fill out everything with a white background.")
                    message_box.visible = true
                }
                else {
                    main_loader.teacherMode = !main_loader.teacherMode
                    console.log("switched mode")

                    if (root.state == "scenario") {
                        if (main_loader.model.qmlFile.indexOf("_cont.qml") !== -1) {
                            main_loader.goBack()
                        } else {
                            main_loader.reload()
                        }
                    }
                }
            }
        }

        Item {
            id: menu_placeholder
            width: exercise_chooser.width
            height: exercise_chooser.height
            visible: exercise_chooser.visible
        }

        ToolbarButton {
            id: open_button
            visible: !_view.isTeacherProgram()
            source: "/icons/document-open.svg"
            tooltip: qsTr("open a stored exercise")

            onClicked: {
                console.log("Open button clicked")
                var exercise = ExerciseLoader.loadStudentExercise()
                if (exercise) {
                    main_loader.setCurrentExercise(0)
                    main_loader.loadNewScreen("/qml/exercises/DidacticScenario.qml", exercise);
                    console.log("Opened student exercise.")
                }
            }
        }

        ToolbarButton {
            id: save_button
            visible: !_view.isTeacherProgram() && root.state == "scenario"
            source: "/icons/document-save.svg"
            tooltip: qsTr("save the current exercise")

            onClicked: {
                console.log("Save student exercise button clicked.")
                main_loader.model.exercises[main_loader.currentExercise].saveStudent()
            }
        }

        ToolbarButton {
            id: print_button
            visible: !_view.isTeacherProgram() && root.state == "scenario"
            source: "/icons/document-print.svg"
            tooltip: qsTr("export the current exercise to print")

            onClicked: {
                console.log("Print student solution button clicked.")
                main_loader.model.exercises[main_loader.currentExercise].printToFile()
            }
        }

        SKrypterTeacherToolbar {
            height: parent.height + 10
            visible: root.state == "scenario" && main_loader.teacherMode
        }

        Item {
            Layout.fillWidth: true
        }

        ToolbarButton {
            id: help_button
            source: "/icons/help.svg"
            tooltip: qsTr("Help")

            onClicked: {
                if (help.visible) {
                    _view.hideHelp(help.width);
                }
                else {
                    _view.showHelp(help.width);
                }

                help.visible = !help.visible
            }
        }

        SKrypterMenu {
            id: language_chooser
            visible: root.state == "startMenu"
            flagOnly: true

            property bool init: true
            z: 2

            onSelectedItemChanged: {
                if (_view.getLanguage() !== language_chooser.model[selectedItem].language) {
                    _view.setLanguage(language_chooser.model[selectedItem].language)
                    message_box.text = qsTr("The language will be changed upon restart of SKrypter.")
                    message_box.visible = true
                }
            }

            Component.onCompleted: {
                var currentLanguage = _view.getLanguage()
                console.log("Language of SKrypter is " + currentLanguage)

                var model = []
                var list = Globals.supported_system_languages
                var startIndex = -1
                for (var i = 0; i < list.length; i++) {
                    if (list[i] === currentLanguage) {
                        startIndex = i
                    }

                    model.push({"language": list[i]})
                }
                language_chooser.model = model
                language_chooser.selectedItem = startIndex
            }
        }

        Item {
            Layout.fillWidth: true
        }

        ToolbarButton {
            id: fs_button
            property bool isFullScreen: false
            source: fs_button.isFullScreen ? "/icons/exit-full-screen.svg" : "/icons/full-screen.svg"
            tooltip: fs_button.isFullScreen ? qsTr("exit full screen") : qsTr("enter full screen")

            onClicked: {
                if (isFullScreen) {
                    _view.exitFullScreen()
                    isFullScreen = false
                }
                else {
                    _view.enterFullScreen()
                    isFullScreen = true
                }
            }
        }

        ToolbarButton {
            id: exit_button
            source: "/icons/quit.svg"
            tooltip: qsTr("exit program")

            onClicked: {
                console.log("QUIT button clicked.")
                Qt.quit()
            }
        }
    }

    Rectangle {
        id: grayOut
        anchors.fill: parent
        color: Globals.gray1
        opacity: 0.5
        visible: !exercise_chooser.isCollapsed

        MouseArea {
            anchors.fill: parent

            onClicked: {
                exercise_chooser.isCollapsed = true
            }
        }
    }

    SKrypterMenu {
        id: exercise_chooser
        x: menu_placeholder.x + rowLayout.x
        y: menu_placeholder.y + rowLayout.y
        visible: root.state == "scenario"
        model: main_loader.model === undefined ? undefined : main_loader.model.exercises
        z: 2

        changeFunction: function(index) {
            if (isCollapsed && root.state == "scenario" && main_loader.teacherMode && main_loader.model.exercises[main_loader.currentExercise].hasChanged())
            {
                question_box.text = qsTr("You have not yet saved your current changes. Are you sure you want to continue?")
                question_box.okFunction = function() {
                    main_loader.model.exercises[main_loader.currentExercise].reset();
                    isCollapsed = !isCollapsed
                    selectedItem = index
                }
                question_box.visible = true
            }
            else {
                isCollapsed = !isCollapsed
                selectedItem = index
            }
        }
    }
}
