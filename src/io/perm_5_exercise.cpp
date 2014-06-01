#include "perm_5_exercise.h"

static const QString type = "Perm5Exercise";

Perm5Exercise::Perm5Exercise(ExerciseList *parent, QString title, QString language, QString filename)
    : Exercise(parent, type, title, language, filename)
    ,m_sortByLetters(true)
{
    m_showCipherText = true;

    m_helpTitle = tr("Perm: Scenario 5");
    m_helpText = tr("Perm 5 Student Help");
    m_teacherHelpText = tr("Perm 5 Teacher Help");
}
