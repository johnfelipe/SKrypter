#ifndef CAESAR_5_EXERCISE_H
#define CAESAR_5_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Caesar5Exercise class
 * Exercise for didactic scenario Caesar 5: Attack
 */
class Caesar5Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(int key MEMBER m_key NOTIFY keyChanged)

    Q_PROPERTY(int studentLives MEMBER m_studentLives NOTIFY studentLivesChanged)
    Q_PROPERTY(QString studentPlainText MEMBER m_studentPlainText NOTIFY studentPlainTextChanged)

public:
    Caesar5Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

    Q_INVOKABLE virtual bool isValid();

signals:
    void keyChanged();

    void studentLivesChanged();
    void studentPlainTextChanged();

private:
    int m_key;

    int m_studentLives;
    QString m_studentPlainText;
};

#endif // CAESAR_5_EXERCISE_H
