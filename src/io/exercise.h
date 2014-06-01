#ifndef EXERCISE_H
#define EXERCISE_H

#include "serializable.h"

class ExerciseList;

/**
 * @brief The Exercise class
 * Super class for all didactic scenario exercises.
 * Contains all common functionality and fields.
 */
class Exercise : public Serializable {
    Q_OBJECT

    /*
     * These are all properties that will be needed for all exercises no
     * matter what didactic scenario they belong to.
     */
    Q_PROPERTY(QString title MEMBER m_title NOTIFY titleChanged)
    Q_PROPERTY(QString language MEMBER m_language NOTIFY languageChanged)
    Q_PROPERTY(bool isBlanks MEMBER m_isBlanks NOTIFY isBlanksChanged)
    Q_PROPERTY(bool isCase MEMBER m_isCase NOTIFY isCaseChanged)
    Q_PROPERTY(QString plainText MEMBER m_plainText NOTIFY plainTextChanged)
    Q_PROPERTY(QString cipherText MEMBER m_cipherText NOTIFY cipherTextChanged)
    Q_PROPERTY(QString helpTextTeacherEdit MEMBER m_helpTextTeacherEdit NOTIFY helpTextTeacherEditChanged)

    //do not store this property, otherwise copying and renaming of files does not work
    Q_PROPERTY(QString filename MEMBER m_filename NOTIFY filenameChanged STORED false)

    // Constant, non editable properties
    Q_PROPERTY(QString helpText MEMBER m_helpText CONSTANT STORED false)
    Q_PROPERTY(QString helpTitle MEMBER m_helpTitle CONSTANT STORED false)
    Q_PROPERTY(QString teacherHelpText MEMBER m_teacherHelpText CONSTANT STORED false)
    Q_PROPERTY(QString type MEMBER m_type CONSTANT STORED false)
    Q_PROPERTY(bool showPlainText MEMBER m_showPlainText CONSTANT STORED false)
    Q_PROPERTY(bool showCipherText MEMBER m_showCipherText CONSTANT STORED false)

    Q_PROPERTY(QString studentSKrypterCheck MEMBER m_studentSKrypterCheck NOTIFY studentSKrypterCheckChanged)

public:
    Exercise(ExerciseList *parent, QString type, QString title, QString language, QString filename = "");
    Exercise();

    /**
     * @brief save
     * Saves the current exercise to file. The exercise is first
     * serialized, then encrypted and written to file.
     * @return returns the position in the exercise list if saveAs is true,
     * otherwise zero. Returns -1 if there was an error when saving.
     */
    Q_INVOKABLE int save(bool saveAs);

    /**
     * @brief save
     * Similar to save, but always asks the user for a new name
     * and saves under a different file ending
     */
    Q_INVOKABLE void saveStudent();

    /**
      * @brief printToFile
      * Saves the current progress of the student to a file in html
      * format, so it can be easily printed out.
      */
    Q_INVOKABLE void printToFile();

    /**
     * @brief load
     * Saves the current exercise is loaded from file.
     */
    Q_INVOKABLE void load();

    /**
     * @brief reset
     * Resets the current exercise by loading again from file.
     */
    Q_INVOKABLE void reset();

    /**
     * @brief hasChanged
     * Returns if the exercise has changed compared to the version stored on disk
     */
    Q_INVOKABLE bool hasChanged();

    /**
     * @brief isValid
     * Returns true if the exercise field are filled out correctly
     */
    Q_INVOKABLE virtual bool isValid();

    /**
     * @brief getRelativePath Returns a path relative to the exercise folder
     * @param path this path is returned relative to the exercise folder
     * @return a string representing a path
     */
    Q_INVOKABLE QString getRelativePath(QString path);

signals:
    void titleChanged();
    void languageChanged();
    void isBlanksChanged();
    void isCaseChanged();
    void plainTextChanged();
    void cipherTextChanged();
    void helpTextTeacherEditChanged();
    void studentSKrypterCheckChanged();

    void filenameChanged();

protected:
    /**
     * @brief serialize
     * Serializes the exercise to a given filename
     * @param filename Path where to save the exercise
     */
    void serialize(QString filename);

    QString m_helpText;
    QString m_helpTitle;
    QString m_teacherHelpText;

    bool m_showPlainText;
    bool m_showCipherText;

private:
    // Fields
    QString m_title;
    QString m_language;
    bool m_isCase;
    bool m_isBlanks;
    QString m_plainText;
    QString m_cipherText;
    QString m_helpTextTeacherEdit;
    QString m_studentSKrypterCheck;

    QString m_filename;
    QString m_type;

    // State
    bool m_isLoaded;

    // Reference doesn't work, because of empty constructor
    ExerciseList *m_exerciseList;
};
#endif // EXERCISE_H
