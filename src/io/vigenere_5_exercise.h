#ifndef VIGENERE_5_EXERCISE_H
#define VIGENERE_5_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Vigenere5Exercise class
 * Exercise for didactic scenario Vigenere 5: Friedman Test
 */
class Vigenere5Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(QString key MEMBER m_key NOTIFY keyChanged)
    Q_PROPERTY(int studentKeyLength MEMBER m_studentKeyLength NOTIFY studentKeyLengthChanged)

    Q_PROPERTY(QString qmlFile MEMBER m_qmlFile NOTIFY qmlFileChanged)
    Q_PROPERTY(QString studentKeyForSecondPart MEMBER m_studentKeyForSecondPart NOTIFY studentKeyForSecondPartChanged)

public:
    Vigenere5Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

    Q_INVOKABLE virtual bool isValid();

signals:
    void keyChanged();
    void studentKeyLengthChanged();

    void qmlFileChanged();
    void studentKeyForSecondPartChanged();

private:
    QString m_key;
    int m_studentKeyLength;

    QString m_qmlFile;
    QString m_studentKeyForSecondPart;
};


#endif // VIGENERE_5_EXERCISE_H
