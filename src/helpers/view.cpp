#include "view.h"

#include <QQuickView>
#include <QQmlContext>
#include <QQmlEngine>
#include <QCoreApplication>
#include <QDebug>
#include <QGuiApplication>
#include <QSettings>


View::View() {

}

void View::start() {
    m_view.rootContext()->setContextProperty("_view", this);
    m_view.setResizeMode(QQuickView::SizeRootObjectToView);
    m_view.setMinimumHeight(getMinimumHeight());
    m_view.setMinimumWidth(getMinimumWidth());
    m_view.setIcon(QIcon(":/icons/appicon.svg"));

    if (isTeacherProgram()) {
        m_view.setTitle("SKrypterTeacher");
    }
    else  {
        m_view.setTitle("SKrypter");
    }

    m_view.setSource(QUrl("qrc:/qml/SKrypter.qml"));

#ifdef Q_OS_MAC
    //this makes that fullscreen works on mac
    m_view.setFlags(m_view.flags() | Qt::WindowFullscreenButtonHint);
#endif

    m_view.show();
    connect(m_view.engine(), SIGNAL(quit()), QCoreApplication::instance(), SLOT(quit()));
}

void View::enterFullScreen() {
    m_view.showFullScreen();
    qDebug() << "Entered Fullscreen";
}

void View::exitFullScreen() {
    m_view.showNormal();
    qDebug() << "Exited Fullscreen";
}

void View::showHelp(int width) {
    if (m_view.windowState() != Qt::WindowFullScreen) {
        m_view.setWidth(m_view.width() + width);
    }
    m_view.setMinimumWidth(getMinimumWidth() + width);
    qDebug() << "Showing help";
}

void View::hideHelp(int width) {
    m_view.setMinimumWidth(getMinimumWidth());
    if (m_view.windowState() != Qt::WindowFullScreen) {
        m_view.setWidth(m_view.width() - width);
    }
    qDebug() << "Hiding Help";
}

void View::setApplicationTitle(QString title) {
    m_view.setTitle(title);
}

bool View::isTeacherProgram() {
#ifdef TEACHER_PROGRAM
    return true;
#else
    return false;
#endif
}

QString View::getLanguage() {
    QSettings settings;
    return settings.value("language", "de").toString();
}

void View::setLanguage(QString language) {
    QSettings settings;
    settings.setValue("language", language);
    qDebug() << "Setting Program language to " + language;
}

int View::getMinimumWidth()
{
    return 800;
}

int View::getMinimumHeight()
{
    return 768;
}
