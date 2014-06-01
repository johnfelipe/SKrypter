#ifndef VIGENERE_2_EXERCISE_H
#define VIGENERE_2_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Vigenere2Exercise class
 * Exercise for didactic scenario Vigenere 2: Key
 */
class Vigenere2Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(QString key MEMBER m_key NOTIFY keyChanged)
    Q_PROPERTY(QString wrongKey MEMBER m_wrongKey NOTIFY wrongKeyChanged)

    Q_PROPERTY(QString studentCorrectedKey MEMBER m_studentCorrectedKey NOTIFY studentCorrectedKeyChanged)

public:
    Vigenere2Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

    Q_INVOKABLE virtual bool isValid();

signals:
    void keyChanged();
    void wrongKeyChanged();

    void studentCorrectedKeyChanged();

private:
    QString m_key;
    QString m_wrongKey;

    QString m_studentCorrectedKey;
};


#endif // VIGENERE_2_EXERCISE_H
