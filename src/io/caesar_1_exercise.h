#ifndef CAESAR_1_EXERCISE_H
#define CAESAR_1_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Caesar1Exercise class
 * Exercise for didactic scenario Caesar 1: Encryption
 */
class Caesar1Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(int studentKey MEMBER m_studentKey NOTIFY studentKeyChanged)
    Q_PROPERTY(QString studentCipherText MEMBER m_studentCipherText NOTIFY studentCipherTextChanged)

public:
    Caesar1Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

signals:
    void studentKeyChanged();
    void studentCipherTextChanged();

private:
    int m_studentKey;
    QString m_studentCipherText;
};

#endif // CAESAR_1_EXERCISE_H
