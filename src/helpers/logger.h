#ifndef LOGGER_H
#define LOGGER_H

#include <QString>
#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QDir>

class Logger : public QObject {
    Q_OBJECT

public:
    Logger();
    ~Logger();

    Q_INVOKABLE void log(QString message, QtMsgType level);

private:
    void deleteOldFiles(QDir logDir);
    QFile m_logfile;
    QTextStream m_fileStream;
};

#endif // LOGGER_H
