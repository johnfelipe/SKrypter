#include "perm_4_exercise.h"

static const QString type = "Perm4Exercise";

Perm4Exercise::Perm4Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
{
    m_showCipherText = true;

    m_helpTitle = tr("Perm: Scenario 4");
    m_helpText = tr("Perm 4 Student Help");
    m_teacherHelpText = tr("Perm 4 Teacher Help");
}
