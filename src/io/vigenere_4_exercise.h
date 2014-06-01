#ifndef VIGENERE_4_EXERCISE_H
#define VIGENERE_4_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Vigenere4Exercise class
 * Exercise for didactic scenario Vigenere 4: FC
 */
class Vigenere4Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(QString key MEMBER m_key NOTIFY keyChanged)
    Q_PROPERTY(bool isRelative MEMBER m_isRelative NOTIFY isRelativeChanged)

    Q_PROPERTY(float studentFCSolution MEMBER m_studentFCSolution NOTIFY studentFCSolutionChanged)

public:
    Vigenere4Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

    Q_INVOKABLE virtual bool isValid();

signals:
    void keyChanged();
    void isRelativeChanged();
    void studentFCSolutionChanged();

private:
    QString m_key;
    bool m_isRelative;

    float m_studentFCSolution;
};

#endif // VIGENERE_4_EXERCISE_H
