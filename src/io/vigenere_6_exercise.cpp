#include "vigenere_6_exercise.h"

static const QString type = "Vigenere6Exercise";

Vigenere6Exercise::Vigenere6Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
    , m_studentKeyLength(-1)
    , m_sinkov(0.0)
{
    m_showCipherText = true;

    m_helpTitle = tr("Vigenère: Scenario 6");
    m_helpText = tr("Vigenère 6 Student Help");
    m_teacherHelpText = tr("Vigenère 6 Teacher Help");
}

bool Vigenere6Exercise::isValid() {
    return !m_key.isEmpty() && m_sinkov >= 0.5 && Exercise::isValid();
}
