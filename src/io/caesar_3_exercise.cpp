#include "caesar_3_exercise.h"

static const QString type = "Caesar3Exercise";

Caesar3Exercise::Caesar3Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
    , m_key(1)
    , m_studentKey(0)
{
    m_showCipherText = true;

    m_helpTitle = tr("Caesar: Scenario 3");
    m_helpText = tr("Caesar 3 Student Help");
    m_teacherHelpText = tr("Caesar 3 Teacher Help");
}

bool Caesar3Exercise::isValid()
{
    return m_key != 0 && Exercise::isValid();
}

