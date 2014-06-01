#include "logger.h"

#include <QDate>
#include <QDir>
#include <QStringList>
#include <QDebug>

#include <string>
#include <iostream>
#include <QApplication>

using namespace std;

Logger::Logger() {
    QDate date = QDate::currentDate();
    QString dateString = date.toString("yyyy_MM_dd");

    QString logDirName = "logs";

    QDir logDir(QApplication::applicationDirPath() + "/" + logDirName);
    if (!logDir.exists()) {
        cout << "Creating log directory " << logDir.path().toStdString() << std::endl;
        if (!logDir.mkpath(".")) {
            cerr << "ERROR: Could not create logdir" << endl;
        }
    }

    QString filename = logDir.absolutePath() + "/log_" + dateString + ".txt";
    m_logfile.setFileName(filename);

    if (!m_logfile.open(QIODevice::Append | QIODevice::Text)) {
        cerr << "ERROR: Could not open logfile " << filename.toStdString() << endl;
    }

    m_fileStream.setDevice(&m_logfile);
    m_fileStream << "============= New Session =============\n";

    deleteOldFiles(logDir);
}

Logger::~Logger() {
    m_fileStream << "\n";
    m_logfile.close();
}

void Logger::log(QString message, QtMsgType level) {
    QTime time = QTime::currentTime();
    QString logMessage = time.toString("HH:mm:ss ");

    switch(level) {
    case QtDebugMsg:
        logMessage += "INFO:\t";
        break;
    case QtWarningMsg:
        logMessage += "WARNING:\t";
        break;
    case QtCriticalMsg:
        logMessage += "CRITICAL:\t";
        break;
    case QtFatalMsg:
        logMessage += "FATAL:\t";
    }

    cout << logMessage.toStdString() << message.toStdString() << endl;
    m_fileStream << logMessage << message << "\n";
}

void Logger::deleteOldFiles(QDir logDir) {
    log("deleting files older than 7 days", QtDebugMsg);

    QStringList filter;
    filter.append("*.txt");
    QStringList logFiles = logDir.entryList(filter);

    QDate dateToday = QDate::currentDate();

    for (int i=0; i<logFiles.size(); i++) {
        QString currentFile = logFiles.at(i);
        QString fileDateString = currentFile.mid(4, 10);
        QDate fileDate = QDate::fromString(fileDateString, "yyyy_MM_dd");

        if (fileDate.isNull()) {
            qWarning() << "Illegal file in log directory: " << currentFile;
        }

        if (fileDate.daysTo(dateToday) > 7) {
            logDir.remove(logFiles.at(i));
        }
    }
}
