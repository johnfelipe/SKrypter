#include "perm_3_exercise.h"

static const QString type = "Perm3Exercise";

Perm3Exercise::Perm3Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
    ,m_sortByLetters(true)
{
    m_showCipherText = true;

    m_helpTitle = tr("Perm: Scenario 3");
    m_helpText = tr("Perm 3 Student Help");
    m_teacherHelpText = tr("Perm 3 Teacher Help");
}
