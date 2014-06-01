#include "caesar_1_exercise.h"

static const QString type = "Caesar1Exercise";

Caesar1Exercise::Caesar1Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
    , m_studentKey(0)
{
    m_showPlainText = true;

    m_helpTitle = tr("Caesar: Scenario 1");
    m_helpText = tr("Caesar 1 Student Help");
    m_teacherHelpText = tr("Caesar 1 Teacher Help");
}
