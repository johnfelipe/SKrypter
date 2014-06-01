#include "perm_6_exercise.h"

static const QString type = "Perm6Exercise";

Perm6Exercise::Perm6Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
    ,m_sortByLetters(true)
{
    m_showCipherText = true;

    m_helpTitle = tr("Perm: Scenario 6");
    m_helpText = tr("Perm 6 Student Help");
    m_teacherHelpText = tr("Perm 6 Teacher Help");
}
