#ifndef EXERCISE_LIST_H
#define EXERCISE_LIST_H

#include "exercise.h"

#include <QQmlListProperty>

/**
 * @brief The ExerciseList class
 * Responsible for handling the list of exercises for
 * one specific Scenario type
 */
class ExerciseList : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString qmlFile MEMBER m_qmlFile)
    Q_PROPERTY(QQmlListProperty<Exercise> exercises READ getExercises NOTIFY exercisesChanged)

public:
    /**
     * @brief ExerciseList
     * Create a new Exercise list
     * @param parent The parent class, required for garbage collection
     * @param qmlFile The associated didactic scenario qml file
     */
    explicit ExerciseList(QObject *parent, QString qmlFile);

    /**
     * @brief ExerciseList
     * Needed for registering with qml. Should never be called
     */
    ExerciseList();

    /**
     * @brief getExercisePosition Returns the position of the current exercise
     * @param exercise The exercise of which the position should be determined
     * @return returns the position. If not found, returns -1
     */
    Q_INVOKABLE int getExercisePosition(Exercise *exercise);

    /**
     * @brief addExercise
     * Adds a new exercise to the list
     * @param exercise The exercise to add
     * @return position in list where exercise was added
     */
    Q_INVOKABLE int addExercise(Exercise* exercise);


    /**
     * @brief deleteExercise
     * deletes the exercise from the list and from disk
     * @param exercise The exercise to delete
     */
    Q_INVOKABLE void deleteExercise(Exercise* exercise);

    /**
     * @brief getExercises
     * Returns the list to qml
     * @return The list of exercises as an array
     */
    QQmlListProperty<Exercise> getExercises();

    /**
     * @brief hasValidExercises
     * @return boolean indicating whether valid exercises are present or not
     */
    Q_INVOKABLE bool hasValidExercises();

    int count() { return m_exercises.count(); }

signals:
    void exercisesChanged();

private:
    QString m_qmlFile;
    QList<Exercise*> m_exercises;
};

#endif // EXERCISE_LIST_H
