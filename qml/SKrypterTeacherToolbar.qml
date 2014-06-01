import QtQuick 2.2
import QtQuick.Controls 1.1

import ExerciseLoader 1.0

import "common"
import "common/Globals.js" as Globals

Rectangle {
    id: root
    width: 5*new_button.height + 4*spacing + 2*margin
    color: Globals.orange1
    radius: 3
    border.color: Globals.blue4

    property int spacing: 20
    property int margin: 5

    property bool newExercise: main_loader.model.exercises ? main_loader.model.exercises[main_loader.currentExercise].filename === "" : false

    Row {
        spacing: root.spacing
        anchors.margins: root.margin
        anchors.fill: parent

        ToolbarButton {
            id: new_button
            height: parent.height
            width: height
            source: "/icons/exercise_new.svg"

            tooltip: qsTr("New exercise of this type")

            function newExercise() {
                console.log("Creating new exercise of type " + main_loader.model.exercises[main_loader.currentExercise].type)
                main_loader.model.exercises[main_loader.currentExercise].reset()

                var exercise = ExerciseLoader.getNewExercise(main_loader.model, main_loader.model.exercises[main_loader.currentExercise].type)
                var position = main_loader.model.addExercise(exercise)
                main_loader.setCurrentExercise(position)
                main_loader.reload()
            }


            onClicked: {
                if (main_loader.model.exercises[main_loader.currentExercise].hasChanged()) {
                    question_box.text = qsTr("You have not yet saved your current changes. Are you sure you want to continue?")

                    question_box.okFunction = newExercise
                    question_box.visible = true
                }
                else {
                    newExercise()
                }
            }
        }

        ToolbarButton {
            id: reset_button
            height: parent.height
            width: height
            source: "/icons/exercise_reset.svg"
            tooltip: qsTr("Return to previously saved version")

            onClicked: {
                question_box.text = qsTr("Do you really want to reset the current exercise? This will load the last saved status of this exercise.")
                question_box.okFunction = function () {
                    console.log("Resetting exercise " + main_loader.model.exercises[main_loader.currentExercise].title)
                    main_loader.model.exercises[main_loader.currentExercise].reset()
                    main_loader.reload()
                }
                question_box.visible = true
            }
        }

        ToolbarButton {
            id: save_button
            height: parent.height
            width: height
            source: "/icons/document-save.svg"
            tooltip: qsTr("Save to disk")

            onClicked: {
                if (!main_loader.model.exercises[main_loader.currentExercise].isValid()) {
                    message_box.text = qsTr("You have not entered all required information for this exercise. Please fill out everything with a white background.")
                    message_box.visible = true
                }
                else {
                    console.log("Saving exercise " + main_loader.model.exercises[main_loader.currentExercise].title)
                    main_loader.model.exercises[main_loader.currentExercise].save(false)
                }
            }
        }

        ToolbarButton {
            id: save_as_button
            height: parent.height
            width: height
            source: "/icons/document-save-as.svg"
            tooltip: qsTr("Save to disk with new filename")

            onClicked: {
                if (!main_loader.model.exercises[main_loader.currentExercise].isValid()) {
                    message_box.text = qsTr("You have not entered all required information for this exercise. Please fill out everything with a white background.")
                    message_box.visible = true
                }
                else {
                    console.log("Saving exercise " + main_loader.model.exercises[main_loader.currentExercise].title + " as")
                    var position = main_loader.model.exercises[main_loader.currentExercise].save(true)
                    if (position !== -1) {
                        main_loader.setCurrentExercise(position)
                    }
                }
            }
        }

        ToolbarButton {
            id: delete_button
            height: parent.height
            width: height
            source: "/icons/exercise_delete.svg"
            tooltip: qsTr("Delete current exercise")

            //or allow delete and automatically add empty exercise again
            enabled: main_loader.model.exercises ? main_loader.model.exercises.length > 1 : true

            onClicked: {
                question_box.text = qsTr("Do you really want to delete the current exercise? This will also delete the exercise from disk.")
                question_box.okFunction = function () {
                    console.log("Deleting exercise " + main_loader.model.exercises[main_loader.currentExercise].filename)
                    var oldExercise = main_loader.currentExercise

                    // prepare exercise to be shown after deletion
                    var newExercise = Math.max(0, oldExercise-1)
                    main_loader.setCurrentExercise(newExercise)

                    // Delete current exercise
                    main_loader.model.deleteExercise(main_loader.model.exercises[oldExercise])

                    // Make sure the new "current" exercise gets correctly loaded
                    main_loader.model.exercises[newExercise].load()
                    main_loader.reload()
                }
                question_box.visible = true
            }
        }
    }
}
