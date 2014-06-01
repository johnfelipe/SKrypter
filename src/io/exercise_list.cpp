#include "exercise_list.h"

#include <QDebug>
#include <QFile>

ExerciseList::ExerciseList(QObject *parent, QString qmlFile)
    : QObject(parent)
    , m_qmlFile(qmlFile) {}

ExerciseList::ExerciseList()
{
    Q_ASSERT_X(false, "ExerciseList::ExerciseList()", "Empty constructor should never be called!");
}

bool sortByName(const Exercise *ex1, const Exercise *ex2)
{
    return ex1->property("title").toString().toLower() < ex2->property("title").toString().toLower();
}

int ExerciseList::getExercisePosition(Exercise *exercise) {
    for (int i=0; i<m_exercises.size(); i++) {
        if (m_exercises[i] == exercise) {
            return i;
        }
    }
    // This should never happen
    return -1;
}

int ExerciseList::addExercise(Exercise* exercise) {
    m_exercises.append(exercise);

    qSort(m_exercises.begin(), m_exercises.end(), sortByName);
    emit exercisesChanged();

    return getExercisePosition(exercise);
}

void ExerciseList::deleteExercise(Exercise *exercise) {
    QString file = exercise->property("filename").toString();

    if (!file.isEmpty())
    {
        //delete the exercise from disk
        if (!QFile::remove(file)) {
            qWarning() << "Could not delete file " << file << " from disk.";
        }
        else {
            qDebug() << "Removed exercise " << file << " from disk";
        }
    }

    //delete the exercise from the exercise list
    int pos = m_exercises.indexOf(exercise);
    if (pos >= 0 && pos < m_exercises.length()) {
        m_exercises.removeAt(pos);
    }
    else {
        qWarning() << "Could not delete file " << file << " from the exercise list.";
    }

    qDebug() << "Removed exercise from the exercise chooser";

    emit exercisesChanged();

}

QQmlListProperty<Exercise> ExerciseList::getExercises() {
    return QQmlListProperty<Exercise>(this, m_exercises);
}

bool ExerciseList::hasValidExercises() {
    bool hasValidExercise = false;
    if (m_exercises.size() <= 0) {
        qDebug() << "size of m_exercises is <=0";
        return false;
    }
    for (int i=0; i<m_exercises.size(); i++) {
        if (!m_exercises[i]->property("filename").toString().isEmpty()) {
            hasValidExercise = true;
            break;
        }
    }

    return hasValidExercise;
}
