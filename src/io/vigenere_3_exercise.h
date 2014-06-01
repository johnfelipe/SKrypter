#ifndef VIGENERE_3_EXERCISE_H
#define VIGENERE_3_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Vigenere3Exercise class
 * Exercise for didactic scenario Vigenere 3: Kasiski
 */
class Vigenere3Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(QString key MEMBER m_key NOTIFY keyChanged)
    Q_PROPERTY(int maxXGrams MEMBER m_maxXGrams NOTIFY maxXGramsChanged)
    Q_PROPERTY(int studentKeyLength MEMBER m_studentKeyLength NOTIFY studentKeyLengthChanged)

    Q_PROPERTY(QString qmlFile MEMBER m_qmlFile NOTIFY qmlFileChanged)
    Q_PROPERTY(int studentGCD MEMBER m_studentGCD NOTIFY studentGCDChanged)
    Q_PROPERTY(QString studentKeyForSecondPart MEMBER m_studentKeyForSecondPart NOTIFY studentKeyForSecondPartChanged)

public:
    Vigenere3Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

    Q_INVOKABLE virtual bool isValid();

signals:
    void keyChanged();
    void maxXGramsChanged();
    void studentKeyLengthChanged();

    void qmlFileChanged();
    void studentGCDChanged();
    void studentKeyForSecondPartChanged();

private:
    QString m_key;
    int m_maxXGrams;
    int m_studentKeyLength;

    QString m_qmlFile;
    int m_studentGCD;
    QString m_studentKeyForSecondPart;

};

#endif // VIGENERE_3_EXERCISE_H
