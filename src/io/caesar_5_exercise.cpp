#include "caesar_5_exercise.h"

static const QString type = "Caesar5Exercise";

Caesar5Exercise::Caesar5Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
    , m_key(1)
    , m_studentLives(3)
{
    m_showCipherText = true;

    m_helpTitle = tr("Caesar: Scenario 5");
    m_helpText = tr("Caesar 5 Student Help");
    m_teacherHelpText = tr("Caesar 5 Teacher Help");
}

bool Caesar5Exercise::isValid()
{
    return m_key != 0 && Exercise::isValid();
}
