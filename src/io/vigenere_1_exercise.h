#ifndef VIGENERE_1_EXERCISE_H
#define VIGENERE_1_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Vigenere1Exercise class
 * Exercise for didactic scenario Vigenere 1: Encrypt
 */
class Vigenere1Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(QString key MEMBER m_key NOTIFY keyChanged)

    Q_PROPERTY(QString studentCipherText MEMBER m_studentCipherText NOTIFY studentCipherTextChanged)

public:
    Vigenere1Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

    Q_INVOKABLE virtual bool isValid();

signals:
    void keyChanged();

    void studentCipherTextChanged();

private:
    QString m_key;
    QString m_studentCipherText;
};

#endif // VIGENERE_1_EXERCISE_H
