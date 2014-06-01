#ifndef VIGENERE_7_EXERCISE_H
#define VIGENERE_7_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Vigenere7Exercise class
 * Exercise for didactic scenario Vigenere 7: Attack
 */
class Vigenere7Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(QString key MEMBER m_key NOTIFY keyChanged)
    Q_PROPERTY(int maxXGrams MEMBER m_maxXGrams NOTIFY maxXGramsChanged)
    Q_PROPERTY(float sinkov MEMBER m_sinkov NOTIFY sinkovChanged STORED false)

    Q_PROPERTY(int studentKeyLength MEMBER m_studentKeyLength NOTIFY studentKeyLengthChanged)
    Q_PROPERTY(QString studentKey MEMBER m_studentKey NOTIFY studentKeyChanged)
    Q_PROPERTY(QString studentPlainText MEMBER m_studentPlainText NOTIFY studentPlainTextChanged)


public:
    Vigenere7Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

    Q_INVOKABLE virtual bool isValid();

signals:
    void keyChanged();
    void maxXGramsChanged();
    void sinkovChanged();

    void studentKeyLengthChanged();
    void studentKeyChanged();
    void studentPlainTextChanged();

private:
    QString m_key;
    int m_maxXGrams;
    float m_sinkov;

    int m_studentKeyLength;
    QString m_studentKey;
    QString m_studentPlainText;
};

#endif // VIGENERE_7_EXERCISE_H
