#include "perm_2_exercise.h"

static const QString type = "Perm2Exercise";

Perm2Exercise::Perm2Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
{
    m_showPlainText = true;
    m_showCipherText = true;

    m_helpTitle = tr("Perm: Scenario 2");
    m_helpText = tr("Perm 2 Student Help");
    m_teacherHelpText = tr("Perm 2 Teacher Help");
}
