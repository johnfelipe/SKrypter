#include "vigenere_3_exercise.h"

static const QString type = "Vigenere3Exercise";

Vigenere3Exercise::Vigenere3Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
    , m_maxXGrams(3)
    , m_studentKeyLength(-1)
    , m_studentGCD(-1)
{
    m_showCipherText = true;

    m_helpTitle = tr("Vigenère: Scenario 3");
    m_helpText = tr("Vigenère 3 Student Help");
    m_teacherHelpText = tr("Vigenère 3 Teacher Help");
}

bool Vigenere3Exercise::isValid() {
    return !m_key.isEmpty() && Exercise::isValid();
}
