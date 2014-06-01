#include "vigenere_1_exercise.h"

static const QString type = "Vigenere1Exercise";

Vigenere1Exercise::Vigenere1Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
{
    m_showPlainText = true;

    m_helpTitle = tr("Vigenère: Scenario 1");
    m_helpText = tr("Vigenère 1 Student Help");
    m_teacherHelpText = tr("Vigenère 1 Teacher Help");
}

bool Vigenere1Exercise::isValid() {
    return !m_key.isEmpty() && Exercise::isValid();
}
