#ifndef PERM_2_EXERCISE_H
#define PERM_2_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Perm2Exercise class
 * Exercise for didactic scenario Perm 2: Key?
 */
class Perm2Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(QString key MEMBER m_key NOTIFY keyChanged)

    Q_PROPERTY(QString studentKey MEMBER m_studentKey NOTIFY studentKeyChanged)


public:
    Perm2Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

signals:
    void keyChanged();

    void studentKeyChanged();


private:
    QString m_key;

    QString m_studentKey;

};


#endif // PERM_2_EXERCISE_H
