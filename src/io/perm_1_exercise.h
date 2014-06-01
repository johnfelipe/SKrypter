#ifndef PERM_1_EXERCISE_H
#define PERM_1_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Perm1Exercise class
 * Exercise for didactic scenario Perm 1: Encryption
 */
class Perm1Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(QString studentKey MEMBER m_studentKey NOTIFY studentKeyChanged)
    Q_PROPERTY(QString studentCipherText MEMBER m_studentCipherText NOTIFY studentCipherTextChanged)

public:
    Perm1Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

signals:
    void studentKeyChanged();
    void studentCipherTextChanged();

private:
    QString m_studentKey;
    QString m_studentCipherText;

};


#endif // PERM_1_EXERCISE_H
