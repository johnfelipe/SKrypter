#include "vigenere_5_exercise.h"

static const QString type = "Vigenere5Exercise";

Vigenere5Exercise::Vigenere5Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
    , m_studentKeyLength(-1)
{
    m_showCipherText = true;

    m_helpTitle = tr("Vigenère: Scenario 5");
    m_helpText = tr("Vigenère 5 Student Help");
    m_teacherHelpText = tr("Vigenère 5 Teacher Help");
}

bool Vigenere5Exercise::isValid() {
    return !m_key.isEmpty() && Exercise::isValid();
}
