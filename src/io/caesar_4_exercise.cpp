#include "caesar_4_exercise.h"

static const QString type = "Caesar4Exercise";

Caesar4Exercise::Caesar4Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
    , m_key(1)
{
    m_showCipherText = true;

    m_helpTitle = tr("Caesar: Scenario 4");
    m_helpText = tr("Caesar 4 Student Help");
    m_teacherHelpText = tr("Caesar 4 Teacher Help");
}

bool Caesar4Exercise::isValid()
{
    return m_key != 0 && Exercise::isValid();
}
