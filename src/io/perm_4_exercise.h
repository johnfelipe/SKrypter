#ifndef PERM_4_EXERCISE_H
#define PERM_4_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Perm4Exercise class
 * Exercise for didactic scenario Perm 4: Bi and Trigrams
 */
class Perm4Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(QString key MEMBER m_key NOTIFY keyChanged)
    Q_PROPERTY(QString keyLockedPositions MEMBER m_keyLockedPositions NOTIFY keyLockedPositionsChanged)

    Q_PROPERTY(QString studentKey MEMBER m_studentKey NOTIFY studentKeyChanged)
    Q_PROPERTY(QString studentKeyLockedPositions MEMBER m_studentKeyLockedPositions NOTIFY studentKeyLockedPositionsChanged)
    Q_PROPERTY(QString studentPlainText MEMBER m_studentPlainText NOTIFY studentPlainTextChanged)

public:
    Perm4Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

signals:
    void keyChanged();
    void keyLockedPositionsChanged();

    void studentKeyChanged();
    void studentKeyLockedPositionsChanged();
    void studentPlainTextChanged();

private:
    QString m_key;
    QString m_keyLockedPositions;

    QString m_studentKey;
    QString m_studentKeyLockedPositions;
    QString m_studentPlainText;
};

#endif // PERM_4_EXERCISE_H
