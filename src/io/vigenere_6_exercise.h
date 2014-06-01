#ifndef VIGENERE_6_EXERCISE_H
#define VIGENERE_6_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Vigenere6Exercise class
 * Exercise for didactic scenario Vigenere 6: Sinkov
 */
class Vigenere6Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(QString key MEMBER m_key NOTIFY keyChanged)
    Q_PROPERTY(int studentKeyLength MEMBER m_studentKeyLength NOTIFY studentKeyLengthChanged)
    Q_PROPERTY(float sinkov MEMBER m_sinkov NOTIFY sinkovChanged STORED false)

    Q_PROPERTY(QString qmlFile MEMBER m_qmlFile NOTIFY qmlFileChanged)
    Q_PROPERTY(QString studentKeyForFirstPart MEMBER m_studentKeyForFirstPart NOTIFY studentKeyForFirstPartChanged)
    Q_PROPERTY(QString studentKeyForSecondPart MEMBER m_studentKeyForSecondPart NOTIFY studentKeyForSecondPartChanged)


public:
    Vigenere6Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

    Q_INVOKABLE virtual bool isValid();

signals:
    void keyChanged();
    void studentKeyLengthChanged();
    void sinkovChanged();

    void qmlFileChanged();
    void studentKeyForFirstPartChanged();
    void studentKeyForSecondPartChanged();

private:
    QString m_key;
    int m_studentKeyLength;
    float m_sinkov;

    QString m_qmlFile;
    QString m_studentKeyForFirstPart;
    QString m_studentKeyForSecondPart;
};

#endif // VIGENERE_6_EXERCISE_H
