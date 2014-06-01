#include "vigenere_2_exercise.h"

static const QString type = "Vigenere2Exercise";

Vigenere2Exercise::Vigenere2Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
{
    m_showPlainText = true;
    m_showCipherText = true;

    m_helpTitle = tr("Vigenère: Scenario 2");
    m_helpText = tr("Vigenère 2 Student Help");
    m_teacherHelpText = tr("Vigenère 2 Teacher Help");
}

bool Vigenere2Exercise::isValid() {
    return !m_key.isEmpty() && !m_wrongKey.isEmpty() && m_key != m_wrongKey && Exercise::isValid();
}
