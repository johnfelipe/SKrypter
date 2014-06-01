#include "exercise.h"

#include <QFileDialog>
#include <QMessageBox>
#include <QDebug>
#include <QApplication>
#include <QMetaProperty>
#include <QDateTime>

#include "file_crypter.h"
#include "exercise_list.h"
#include "exercise_loader.h"

Exercise::Exercise() {
    Q_ASSERT_X(false, "Exercise::Exercise()", "Empty constructor should never be called!");
}

Exercise::Exercise(ExerciseList *parent, QString type, QString title, QString language, QString filename)
    : Serializable(parent)
    , m_showPlainText(false)
    , m_showCipherText(false)
    , m_title(title)
    , m_language(language)
    , m_isCase(false)
    , m_isBlanks(true)
    , m_studentSKrypterCheck("in progress")
    , m_filename(filename)
    , m_type(type)
    , m_isLoaded(filename.isEmpty())
    , m_exerciseList(parent) {
}

void Exercise::saveStudent() {
    QString filename = QFileDialog::getSaveFileName(NULL, tr("Select path"), tr("my_exercise.skp"), tr("SKrypter Partial Solutions (*.skp)"));
    if (filename.isEmpty()) {
        qDebug() << "Empty filename, not saving";
        return;
    }

    if (!filename.endsWith(".skp")) {
        filename = filename + ".skp";
    }

    serialize(filename);
    qDebug() << "Saved student exercise " << filename;
}

void Exercise::printToFile() {
    QString filename = QFileDialog::getSaveFileName(NULL, tr("Select path"), tr("my_exercise.html"), tr("HTML Webpage (*.html)"));
    if (filename.isEmpty()) {
        qDebug() << "Empty filename, not saving";
        return;
    }

    if (!filename.endsWith(".html")) {
        filename = filename + ".html";
    }

    QDateTime dateTime = QDateTime::currentDateTime();


    QFile file(filename);
    file.open(QIODevice::WriteOnly);

    QTextStream fileStream(&file);

#ifdef Q_OS_WIN
    fileStream << "<html>\n<head>\n<meta http-equiv='Content-Type'' content='text/html; charset=ISO-8859-1'>";
#else
    fileStream << "<html>\n<head>\n<meta http-equiv='Content-Type'' content='text/html; charset=utf-8'>";
#endif
    fileStream << "<title>" << tr("SKrypter Student Solution") << "</title>\n</head>\n<body>";
    fileStream << "<h1><span style='color:#0b5da2;'>SKrypter</span></h1>\n";
    fileStream << "<p>" << tr("Created on") << " " << dateTime.toString("d.M.yy") << " " << tr("at") << " " << dateTime.toString("HH:mm") << "</p>";
    fileStream << "<h2>" << m_type.replace("Exercise", "") <<  " - " << tr("Exercise") << " " << m_title << "</h2>\n";
    fileStream << "<h4>" << tr("Student Solution") << "</h4>";

    qDebug() << m_studentSKrypterCheck;
    for (int i=0; i<metaObject()->propertyCount(); i++) {
        if (metaObject()->property(i).isStored(this)) {
            QString name = metaObject()->property(i).name();

            if (name.startsWith("student")) {
                fileStream << "<p>" << name.replace("student", "") << ": ";
                fileStream << metaObject()->property(i).read(this).toString() << "</p>";
            }
        }
    }

    fileStream << "</body>\n</html>";

    file.close();
    qDebug() << "Printed student exercise " << filename;
}

void Exercise::serialize(QString filename) {
    FileCrypter crypter;
    QDataStream *stream = crypter.getWriteStream();
    if (!stream) {
        qWarning() << "Could not save to file";
        return;
    }

    *stream << m_title;
    *stream << m_language;
    *stream << m_type;
    *stream << *this;

    crypter.closeWriteStream(filename);
}

int Exercise::save(bool saveAs) {
    Q_ASSERT_X(isValid(), "Exercise::save()", "Has to be valid to save an exercise");

    if (m_filename.isEmpty() || saveAs) {
        QString filename = QFileDialog::getSaveFileName(NULL, tr("Select path"), QApplication::applicationDirPath() + "/exercises/" + m_title + ".ske", tr("SKrypter Exercises (*.ske)"), 0, QFileDialog::DontConfirmOverwrite);
        if (filename.isEmpty()) {
            qDebug() << "Empty filename, not saving exercise";
            return -1;
        }

        if (!filename.endsWith(".ske")) {
            filename = filename + ".ske";
        }

        if(QFile::exists(filename)) {
            QMessageBox msgBox;
            msgBox.setText(tr("Cannot overwrite existing file. Please delete it first from within SKrypter."));
            msgBox.exec();
            return -1;
        }

        if (saveAs && m_exerciseList) {
            //ensure that the old exercise is still available not only on disk
            Exercise *oldExercise = ExerciseLoader::getNewExercise(m_exerciseList, m_type, m_filename, m_language, m_title);
            oldExercise->reset();
            m_exerciseList->addExercise(oldExercise);
        }

        m_filename = filename;
        emit filenameChanged();
    }

    FileCrypter crypter;
    QDataStream *stream = crypter.getWriteStream();
    if (!stream) {
        qWarning() << "Could not save to file";
        return -1;
    }

    *stream << m_title;
    *stream << m_language;
    *stream << m_type;
    *stream << *this;

    crypter.closeWriteStream(m_filename);

    qDebug() << "Saved exercise under " << m_filename;

    if (saveAs) {
        return m_exerciseList->getExercisePosition(this);
    }
    else {
        return -1;
    }
}


void Exercise::load() {
    if (m_isLoaded) {
        return;
    }

    if (m_filename.isEmpty()) {
        // Load defaults
        ExerciseList list(NULL, "");
        Exercise *diskExercise = ExerciseLoader::getNewExercise(&list, m_type, m_filename);

        for (int i=0; i<this->metaObject()->propertyCount(); i++) {
            QMetaProperty currentProperty = this->metaObject()->property(i);
            if (currentProperty.isStored()) {
                currentProperty.write(this, diskExercise->property(currentProperty.name()));
            }
        }

        return;
    }

    FileCrypter crypter;
    QDataStream *stream = crypter.getReadStream(m_filename);
    if (!stream) {
        qWarning() << "Could not load file";
        return;
    }

    // Have to read title, language and type, even though we don't
    // actually need it here
    QString tmp;
    *stream >> tmp;
    *stream >> tmp;
    *stream >> tmp;
    *stream >> *this;

    crypter.closeReadStream();

    m_isLoaded = true;
    qDebug() << "Fully loaded exercise " << m_filename;
}

void Exercise::reset() {
    m_isLoaded = false;
    load();
    qDebug() << "Reset exercise " << m_title;
}

bool Exercise::hasChanged() {
    // Create exercise copy
    ExerciseList list(NULL, "");
    Exercise *diskExercise = ExerciseLoader::getNewExercise(&list, m_type, m_filename);
    diskExercise->load();

    // Check for all stored properties if they're still the same
    for (int i=0; i<this->metaObject()->propertyCount(); i++) {
        QMetaProperty currentProperty = this->metaObject()->property(i);
        if (currentProperty.isStored() && !QString(currentProperty.name()).startsWith("student") && !QString(currentProperty.name()).startsWith("hidden")) {
            if (property(currentProperty.name()) != diskExercise->property(currentProperty.name())) {
                return true;
            }
        }
    }

    return false;
}

bool Exercise::isValid() {
    return m_title.trimmed().count() > 0 && m_plainText.trimmed().count() > 0;
}

QString Exercise::getRelativePath(QString path) {
    return QDir(QApplication::applicationDirPath() + "/exercises/").relativeFilePath(path);
}
