#ifndef CAESAR_3_EXERCISE_H
#define CAESAR_3_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Caesar3Exercise class
 * Exercise for didactic scenario Caesar 3: Brute Force
 */
class Caesar3Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(int key MEMBER m_key NOTIFY keyChanged)

    Q_PROPERTY(int studentKey MEMBER m_studentKey NOTIFY studentKeyChanged)
    Q_PROPERTY(QString studentPlainText MEMBER m_studentPlainText NOTIFY studentPlainTextChanged)

public:
    Caesar3Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

    Q_INVOKABLE virtual bool isValid();

signals:
    void keyChanged();

    void studentKeyChanged();
    void studentPlainTextChanged();

private:
    int m_key;

    int m_studentKey;
    QString m_studentPlainText;
};

#endif // CAESAR_3_EXERCISE_H
