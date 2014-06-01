#ifndef CAESAR_4_EXERCISE_H
#define CAESAR_4_EXERCISE_H

#include "exercise.h"
#include "QVariantList"

/**
 * @brief The Caesar4Exercise class
 * Exercise for didactic scenario Caesar 4: Frequencies
 */
class Caesar4Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(int key MEMBER m_key NOTIFY keyChanged)

    Q_PROPERTY(QString studentLetters MEMBER m_studentLetters NOTIFY studentLettersChanged)
    Q_PROPERTY(QVariantList hiddenCounter MEMBER m_counter NOTIFY counterChanged)

public:
    Caesar4Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

    Q_INVOKABLE virtual bool isValid();

signals:
    void keyChanged();

    void studentLettersChanged();
    void counterChanged();

private:
    int m_key;

    QString m_studentLetters;
    QVariantList m_counter;
};


#endif // CAESAR_4_EXERCISE_H
