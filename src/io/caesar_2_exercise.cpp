#include "caesar_2_exercise.h"

static const QString type = "Caesar2Exercise";

Caesar2Exercise::Caesar2Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
    , m_key(1)
    , m_studentKey(0)
{
    m_showCipherText = true;

    m_helpTitle = tr("Caesar: Scenario 2");
    m_helpText = tr("Caesar 2 Student Help");
    m_teacherHelpText = tr("Caesar 2 Teacher Help");
}

bool Caesar2Exercise::isValid() {
    return !m_plainLetter.isEmpty() && !m_cipherLetter.isEmpty() && m_plainLetter != m_cipherLetter && Exercise::isValid();
}
