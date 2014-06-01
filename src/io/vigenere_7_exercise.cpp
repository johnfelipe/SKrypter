#include "vigenere_7_exercise.h"

static const QString type = "Vigenere7Exercise";

Vigenere7Exercise::Vigenere7Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
    , m_maxXGrams(3)
    , m_studentKeyLength(-1)
{
    m_showCipherText = true;

    m_helpTitle = tr("Vigenère: Scenario 7");
    m_helpText = tr("Vigenère 7 Student Help");
    m_teacherHelpText = tr("Vigenère 7 Teacher Help");
}

bool Vigenere7Exercise::isValid() {
    return !m_key.isEmpty() && m_sinkov >= 0.5 && Exercise::isValid();
}
