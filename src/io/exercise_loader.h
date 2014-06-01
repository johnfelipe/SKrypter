#ifndef EXERCISE_LOADER_H
#define EXERCISE_LOADER_H

#include "exercise_list.h"

#include <QDir>

/**
 * @brief The ExerciseLoader class
 * This class is responsible for loading all exercises from
 * the exercise folder. It will also store a list of all
 * exercise lists (one for each didactic scenario) in its
 * member variable. This is accessible from QML
 */
class ExerciseLoader : public QObject {
    Q_OBJECT

public:
    ExerciseLoader();

    /**
     * @brief ExerciseLoader::loadExercises
     * Loads all exercises from the exercise folder and stores
     * them in the appropriate exercise list.
     */
    Q_INVOKABLE void loadExercises();

    /**
     * @brief ExerciseLoader::getList
     * Returns the exercise list of type
     * @param type Indacates the didactic scenario
     * @return the list
     */
    Q_INVOKABLE ExerciseList* getList(QString type);

    /**
      * @brief ExerciseLoader::loadStudentExercise
      * Returns an ExerciseList containing exactly
      * one exercise, which was selected by the user.
      * For consistency reasons and reusability we need
      * a list and not the pure exersise
      * @return the list
      */
    Q_INVOKABLE ExerciseList *loadStudentExercise();

    /**
     * @brief ExerciseLoader::getNewExercise
     * Returns a new exercise of the correct subclass
     * @param list The parent list
     * @param type Indacates the didactic scenario
     * @param file The filename. Defaults to ""
     * @param language The language, for example "de" or "en". Defaults to "de"
     * @param title The title of the new exercise. Defaults to ""
     * @return A pointer to the new exercise
     */
    Q_INVOKABLE static Exercise* getNewExercise(ExerciseList *list, QString type, QString file = "", QString language = "de", QString title = "");

private:
    QMap<QString, ExerciseList*> m_exerciseLists;

    /**
     * @brief readExercisesInFolder
     * Loops through the exercises in a folder and adds them
     * to m_exerciseLists
     * @param exerciseDir The directory to search exercises in
     */
    void readExercisesInFolder(QDir exerciseDir);

    /**
     * @brief findExercisesInSubfolders
     * Loops through all subfolders and finds additional folders
     * and exercises (using readExercisesInFolder)
     * @param exerciseDir The directory to search exercises in and
     * subfolders in
     */
    void findExercisesInSubfolders(QDir exerciseDir);

    /**
     * @brief getExerciseFromFile
     * Loads an exercise from the given filename and adds it to the given list
     * @param exerciseList The list where the exercise should be added to. If NULL is given, puts
     * it in the internal list m_exerciseLists
     * @param filename The path of the file that should be loaded
     * @return The exercise, or NULL if it could not be loaded
     */
    Exercise *getExerciseFromFile(ExerciseList *exerciseList, QString filename);
};

#endif // EXERCISE_LOADER_H
