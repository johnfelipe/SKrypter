#include "vigenere_4_exercise.h"

static const QString type = "Vigenere4Exercise";

Vigenere4Exercise::Vigenere4Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
    , m_isRelative(false)
    , m_studentFCSolution(0.0)
{
    m_showCipherText = true;

    m_helpTitle = tr("Vigenère: Scenario 4");
    m_helpText = tr("Vigenère 4 Student Help");
    m_teacherHelpText = tr("Vigenère 4 Teacher Help");
}

bool Vigenere4Exercise::isValid() {
    return !m_key.isEmpty() && Exercise::isValid();
}
