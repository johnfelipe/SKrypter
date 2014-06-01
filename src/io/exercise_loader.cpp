#include "exercise_loader.h"

#include <QDir>
#include <QApplication>
#include <QDebug>
#include <QFileDialog>

#include "caesar_1_exercise.h"
#include "caesar_2_exercise.h"
#include "caesar_3_exercise.h"
#include "caesar_4_exercise.h"
#include "caesar_5_exercise.h"

#include "perm_1_exercise.h"
#include "perm_2_exercise.h"
#include "perm_3_exercise.h"
#include "perm_4_exercise.h"
#include "perm_5_exercise.h"
#include "perm_6_exercise.h"

#include "vigenere_1_exercise.h"
#include "vigenere_2_exercise.h"
#include "vigenere_3_exercise.h"
#include "vigenere_4_exercise.h"
#include "vigenere_5_exercise.h"
#include "vigenere_6_exercise.h"
#include "vigenere_7_exercise.h"


#include "file_crypter.h"

const static QString exerciseFolder = "exercises";

ExerciseLoader::ExerciseLoader() {
    // Setup empty lists
    m_exerciseLists["Caesar1Exercise"] = new ExerciseList(this, "/qml/exercises/caesar/Caesar_1.qml");
    m_exerciseLists["Caesar2Exercise"] = new ExerciseList(this, "/qml/exercises/caesar/Caesar_2.qml");
    m_exerciseLists["Caesar3Exercise"] = new ExerciseList(this, "/qml/exercises/caesar/Caesar_3.qml");
    m_exerciseLists["Caesar4Exercise"] = new ExerciseList(this, "/qml/exercises/caesar/Caesar_4.qml");
    m_exerciseLists["Caesar5Exercise"] = new ExerciseList(this, "/qml/exercises/caesar/Caesar_5.qml");

    m_exerciseLists["Perm1Exercise"] = new ExerciseList(this, "/qml/exercises/perm/Perm_1.qml");
    m_exerciseLists["Perm2Exercise"] = new ExerciseList(this, "/qml/exercises/perm/Perm_2.qml");
    m_exerciseLists["Perm3Exercise"] = new ExerciseList(this, "/qml/exercises/perm/Perm_3.qml");
    m_exerciseLists["Perm4Exercise"] = new ExerciseList(this, "/qml/exercises/perm/Perm_4.qml");
    m_exerciseLists["Perm5Exercise"] = new ExerciseList(this, "/qml/exercises/perm/Perm_5.qml");
    m_exerciseLists["Perm6Exercise"] = new ExerciseList(this, "/qml/exercises/perm/Perm_6.qml");

    m_exerciseLists["Vigenere1Exercise"] = new ExerciseList(this, "/qml/exercises/vigenere/Vigenere_1.qml");
    m_exerciseLists["Vigenere2Exercise"] = new ExerciseList(this, "/qml/exercises/vigenere/Vigenere_2.qml");
    m_exerciseLists["Vigenere3Exercise"] = new ExerciseList(this, "/qml/exercises/vigenere/Vigenere_3.qml");
    m_exerciseLists["Vigenere4Exercise"] = new ExerciseList(this, "/qml/exercises/vigenere/Vigenere_4.qml");
    m_exerciseLists["Vigenere5Exercise"] = new ExerciseList(this, "/qml/exercises/vigenere/Vigenere_5.qml");
    m_exerciseLists["Vigenere6Exercise"] = new ExerciseList(this, "/qml/exercises/vigenere/Vigenere_6.qml");
    m_exerciseLists["Vigenere7Exercise"] = new ExerciseList(this, "/qml/exercises/vigenere/Vigenere_7.qml");
}

void ExerciseLoader::findExercisesInSubfolders(QDir exerciseDir) {
    readExercisesInFolder(exerciseDir);

    exerciseDir.setFilter(QDir::Dirs | QDir::NoDotAndDotDot);
    QStringList exerciseFolders = exerciseDir.entryList();

    for (int i=0; i<exerciseFolders.size(); i++) {
        QString currentFolder = exerciseDir.path() + "/" + exerciseFolders[i];
        findExercisesInSubfolders(currentFolder);
    }
}

void ExerciseLoader::readExercisesInFolder(QDir exerciseDir) {
    // Loop through all "ske" files
    exerciseDir.setNameFilters(QStringList() << "*.ske");
    QStringList exerciseFiles = exerciseDir.entryList();
    for (int i=0; i<exerciseFiles.size(); i++) {
        QString currentFile = exerciseDir.path() + "/" + exerciseFiles[i];
        getExerciseFromFile(NULL, currentFile);
    }
}

void ExerciseLoader::loadExercises() {
    QDir exerciseDir(QApplication::applicationDirPath() + "/" + exerciseFolder);
    if (!exerciseDir.exists()) {
        qDebug() << "Creating exercise directory";
        if (!exerciseDir.mkpath(".")) {
            qFatal("ERROR: Could not create exercise directory");
        }
    }

    findExercisesInSubfolders(exerciseDir);

    QMap<QString, ExerciseList*>::iterator it;
    //check that all didactic scenarios have at least one empty exercise (needed in teacher mode)
    for (it = m_exerciseLists.begin(); it != m_exerciseLists.end(); ++it) {
        if (it.value()->count() == 0) {
            it.value()->addExercise(getNewExercise(it.value(), it.key()));
        }
    }

    qDebug() << "Initial loading of exercises done.";
}

ExerciseList *ExerciseLoader::getList(QString type) {
    return m_exerciseLists[type];
}

Exercise *ExerciseLoader::getExerciseFromFile(ExerciseList *exerciseList, QString filename) {
    FileCrypter fileCrypter;
    QDataStream *stream = fileCrypter.getReadStream(filename);

    if (stream == NULL) {
        qWarning() << "Corrupt file '" << filename << "', could not get stream";
        return NULL;
    }

    // Read only needed information (=title, type, language), NOT the full file
    QString title;
    *stream >> title;
    QString language;
    *stream >> language;
    QString type;
    *stream >> type;
    fileCrypter.closeReadStream();

    if (!exerciseList) {
        exerciseList = getList(type);
    }

    Exercise *exercise = getNewExercise(exerciseList, type, filename, language, title);
    if (!exercise) {
        qWarning() << "Corrupt file'" << filename << "', could not load exercise";
        return NULL;
    }

    exerciseList->addExercise(exercise);
    return exercise;
}

ExerciseList *ExerciseLoader::loadStudentExercise() {
    QString filename = QFileDialog::getOpenFileName(NULL, tr("Select path"), "", tr("SKrypter Partial Solutions (*.skp)"));
    if (filename.isEmpty()) {
        qDebug() << "Empty filename, not loading";
        return NULL;
    }

    ExerciseList *list = new ExerciseList(this, "");
    Exercise *exercise = getExerciseFromFile(list, filename);

    if (exercise) {
        bool alreadyLoaded = false;
        if (exercise->property("qmlFile").isValid()) {
            exercise->load();
            if (!exercise->property("qmlFile").toString().isEmpty()) {
                list->setProperty("qmlFile", exercise->property("qmlFile").toString());
                alreadyLoaded = true;
            }
        }
        if (!alreadyLoaded) {
            list->setProperty("qmlFile", m_exerciseLists[exercise->property("type").toString()]->property("qmlFile"));
        }
    }
    else {
        delete list;
        list = NULL;
    }

    qDebug() << "Loaded student saved exercise " << filename;
    return list;
}

Exercise *ExerciseLoader::getNewExercise(ExerciseList *list, QString type, QString file, QString language, QString title)
{
    if (type == "Caesar1Exercise") {
        return new Caesar1Exercise(list, title, language, file);
    }
    else if (type == "Caesar2Exercise") {
        return new Caesar2Exercise(list, title, language, file);
    }
    else if (type == "Caesar3Exercise") {
        return new Caesar3Exercise(list, title, language, file);
    }
    else if (type == "Caesar4Exercise") {
        return new Caesar4Exercise(list, title, language, file);
    }
    else if (type == "Caesar5Exercise") {
        return new Caesar5Exercise(list, title, language, file);
    }
    else if (type == "Perm1Exercise") {
        return new Perm1Exercise(list, title, language, file);
    }
    else if (type == "Perm2Exercise") {
        return new Perm2Exercise(list, title, language, file);
    }
    else if (type == "Perm3Exercise") {
        return new Perm3Exercise(list, title, language, file);
    }
    else if (type == "Perm4Exercise") {
        return new Perm4Exercise(list, title, language, file);
    }
    else if (type == "Perm5Exercise") {
        return new Perm5Exercise(list, title, language, file);
    }
    else if (type == "Perm6Exercise") {
        return new Perm6Exercise(list, title, language, file);
    }
    else if (type == "Vigenere1Exercise") {
        return new Vigenere1Exercise(list, title, language, file);
    }
    else if (type == "Vigenere2Exercise") {
        return new Vigenere2Exercise(list, title, language, file);
    }
    else if (type == "Vigenere3Exercise") {
        return new Vigenere3Exercise(list, title, language, file);
    }
    else if (type == "Vigenere4Exercise") {
        return new Vigenere4Exercise(list, title, language, file);
    }
    else if (type == "Vigenere5Exercise") {
        return new Vigenere5Exercise(list, title, language, file);
    }
    else if (type == "Vigenere6Exercise") {
        return new Vigenere6Exercise(list, title, language, file);
    }
    else if (type == "Vigenere7Exercise") {
        return new Vigenere7Exercise(list, title, language, file);
    }
    else {
        qWarning() << "Unknown type '" << type << "'";
        return NULL;
    }
}
