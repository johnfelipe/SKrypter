#ifndef CAESAR_2_EXERCISE_H
#define CAESAR_2_EXERCISE_H

#include "exercise.h"

/**
 * @brief The Caesar2Exercise class
 * Exercise for didactic scenario Caesar 2: Decryption
 */
class Caesar2Exercise : public Exercise {
    Q_OBJECT

    Q_PROPERTY(QString cipherLetter MEMBER m_cipherLetter NOTIFY cipherLetterChanged)
    Q_PROPERTY(QString plainLetter MEMBER m_plainLetter NOTIFY plainLetterChanged)
    Q_PROPERTY(int key MEMBER m_key NOTIFY keyChanged)

    Q_PROPERTY(int studentKey MEMBER m_studentKey NOTIFY studentKeyChanged)
    Q_PROPERTY(QString studentPlainText MEMBER m_studentPlainText NOTIFY studentPlainTextChanged)

public:
    Caesar2Exercise(ExerciseList *parent = NULL, QString title = "", QString language = "de", QString filename = "");

    Q_INVOKABLE virtual bool isValid();

signals:
    void cipherLetterChanged();
    void plainLetterChanged();
    void keyChanged();

    void studentKeyChanged();
    void studentPlainTextChanged();

private:
    QString m_plainLetter;
    QString m_cipherLetter;
    int m_key;

    int m_studentKey;
    QString m_studentPlainText;
};

#endif // CAESAR_2_EXERCISE_H
