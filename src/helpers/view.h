#ifndef VIEW_H
#define VIEW_H

#include <QObject>
#include <QQuickView>

#include "stats.h"

class View : public QObject {
    Q_OBJECT

public:
    View();

    /**
     * @brief start initializes the view object. This is not done in the
     * constructor due to the translator having to be installed first in
     * main.cpp
     */
    void start();

    /**
     * @brief enterFullScreen Makes the application window fullscreen
     */
    Q_INVOKABLE void enterFullScreen();

    /**
     * @brief enterFullScreen Restores the previous window state
     */
    Q_INVOKABLE void exitFullScreen();

    /**
     * @brief showHelp Displays the help fold out area at the right border
     * @param width By how many pixels should the main window be enlarged
     */
    Q_INVOKABLE void showHelp(int width);

    /**
     * @brief hideHelp Makes the window smaller, so the help disappears
     * @param width By how many pixels should the main window be shrunk
     */
    Q_INVOKABLE void hideHelp(int width);

    /**
     * @brief setApplicationTitle Sets the title of the application window
     * @param title The new title to be displayed
     */
    Q_INVOKABLE void setApplicationTitle(QString title);

    /**
     * @brief isTeacherProgram Function to check whether SKrypter is compiled in teacher program
     * @return true if teacher functionality is allowed
     */
    Q_INVOKABLE bool isTeacherProgram();

    /**
     * @brief getLanguage Returns the program language stored in settings
     * @return
     */
    Q_INVOKABLE QString getLanguage();

    /**
     * @brief setLanguage sets the language stored in settings to the language
     * the new language is applied after program restart
     * @param language the program language selected by the user
     */
    Q_INVOKABLE void setLanguage(QString language);

    /**
     * @brief getMinimumWidth
     * @return the minimum width the application window has to have
     */
    Q_INVOKABLE int getMinimumWidth();

    /**
    * @brief getMinimumHeight
    * @return the minimum height the application window has to have
    */
    Q_INVOKABLE int getMinimumHeight();

private:
    QQuickView m_view;
};

#endif // VIEW_H
