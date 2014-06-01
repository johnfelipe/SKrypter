#include "perm_1_exercise.h"

static const QString type = "Perm1Exercise";

Perm1Exercise::Perm1Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
{
    m_showPlainText = true;

    m_helpTitle = tr("Perm: Scenario 1");
    m_helpText = tr("Perm 1 Student Help");
    m_teacherHelpText = tr("Perm 1 Teacher Help");
}
