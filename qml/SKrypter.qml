import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import "common"
import ExerciseLoader 1.0

import "common/Globals.js" as Globals

/**
 * This class is responsible for creating the entire window. It contains all
 * functionality for the toolbar.
 * The content is loaded dynamically with a Loader.
 * Additionally the help is also handled via this class.
 */
Rectangle {
    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        Item {

            Layout.fillWidth: true
            Layout.minimumWidth: _view.getMinimumWidth()

            ColumnLayout {
                spacing: 0
                anchors.fill: parent
                SKrypterToolbar {
                    id: toolbar

                    height: 60
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: main_loader.teacherMode ? Globals.orange1 : Globals.gray1

                    Loader {
                        id: main_loader
                        anchors.fill: parent

                        // model to pass information to loaded item
                        property var model

                        property bool teacherMode: _view.isTeacherProgram()

                        // current exercise set from exercise chooser in menu bar
                        // forwarded to loaded content
                        property int currentExercise: toolbar.exercise_chooser.selectedItem

                        function setCurrentExercise(exercise) {
                            toolbar.exercise_chooser.selectedItem = exercise
                        }

                        //stacks that keep history of source and help to be displayed
                        property var sourceStack: []
                        property var modelStack: []

                        //pops the current source and model and load the previous one
                        function goBack(qmlFile, newModel) {
                            main_loader.sourceComponent = undefined
                            main_loader.model = modelStack.pop()
                            setExerciseSource(sourceStack.pop())

                            var name = "SKrypter"
                            if (_view.isTeacherProgram()) {
                                name = "SKrypterTeacher"
                            }
                            _view.setApplicationTitle(name)
                        }

                        //loaded elements can call this function to change the screen
                        function loadNewScreen(qmlFile, newModel) {
                            sourceStack.push(source.toString())
                            modelStack.push(model)

                            //finish loading file from disk if needed
                            if (newModel.exercises) {
                                newModel.exercises[currentExercise].load()
                            }

                            main_loader.sourceComponent = undefined
                            main_loader.model = newModel
                            setExerciseSource(qmlFile)

                            var name = "SKrypter"
                            if (_view.isTeacherProgram()) {
                                name = "SKrypterTeacher"
                            }
                            if (main_loader.item && main_loader.item.exercise) {
                                name = name + " - " + main_loader.item.exercise.helpTitle
                            }
                            _view.setApplicationTitle(name)
                        }


                        function reload() {
                            var currentSource = main_loader.source
                            main_loader.sourceComponent = undefined
                            setExerciseSource(currentSource)
                        }

                        function setExerciseSource(value) {
                            main_loader.setSource(value, {"exercise":
                                                      main_loader.model && main_loader.model.exercises ?
                                                          main_loader.model.exercises[main_loader.currentExercise] : undefined})
                        }

                        //use this function only when you do not want to push the screen to the stack!!!
                        //pressing back button will then jump back "2" screens.
                        function overwriteCurrentScreen(qmlFile, newModel) {
                            main_loader.sourceComponent = undefined
                            main_loader.model = newModel
                            setExerciseSource(qmlFile)
                        }

                        onCurrentExerciseChanged: {
                            //finish loading file from disk if needed
                            if (model.exercises) {
                                model.exercises[currentExercise].load()
                            }

                            reload()
                        }

                        onSourceChanged: {
                            console.log("Loading file " + source)

                            //need to change state
                            if (source == Qt.resolvedUrl("StartMenu.qml")) {
                                toolbar.state = "startMenu"
                            }
                            else if (source.toString().match(/exercises\/.*\/.*Main\.qml/)) {
                                toolbar.state = "csMenu"
                            }
                            else if (source == Qt.resolvedUrl("About.qml")){
                                toolbar.state = "about"
                            }
                            else {
                                toolbar.state = "scenario"
                            }
                        }
                    }

                    Rectangle {
                        id: grayOut
                        anchors.fill: parent
                        color: Globals.gray1
                        opacity: 0.5
                        visible: !toolbar.exercise_chooser.isCollapsed

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                toolbar.exercise_chooser.isCollapsed = true
                            }
                        }
                    }
                }
            }

            QuestionBox {
                id: question_box
                anchors.fill: parent
                visible: false
            }

            MessageBox {
                id: message_box
                anchors.fill: parent
                visible: false
            }
        }

        Help {
            id: help
            visible: false
            Layout.minimumWidth: 200
            title: {
                if (main_loader.model && main_loader.model.helpTitle) {
                    return main_loader.model.helpTitle
                }
                if (main_loader.item && main_loader.item.exercise) {
                    return main_loader.item.exercise.helpTitle
                }
                return ""
            }
            text:  {
                if (main_loader.model && main_loader.model.helpText) {
                    return main_loader.model.helpText
                }
                if (main_loader.teacherMode && main_loader.item && main_loader.item.exercise) {
                    return main_loader.item.exercise.teacherHelpText
                }
                if (main_loader.item && main_loader.item.exercise) {
                    if (main_loader.item.exercise.helpTextTeacherEdit) {
                        return main_loader.item.exercise.helpTextTeacherEdit
                    }
                    else {
                        return main_loader.item.exercise.helpText
                    }
                }
                return ""
            }
        }
    }

    Component.onCompleted: {
        main_loader.source = "StartMenu.qml"
        main_loader.model = {helpTitle: qsTr("Overview Help Cryptosystems"), helpText: qsTr("To start simply click on any of the available cryptosystems. We recommend to work them through in order.")}
        ExerciseLoader.loadExercises()
    }
}
