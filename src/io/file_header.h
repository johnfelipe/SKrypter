#ifndef FILE_HEADER_H
#define FILE_HEADER_H

#include <QObject>

class FileHeader : public QObject
{
    Q_OBJECT

     Q_PROPERTY(QString title MEMBER m_title NOTIFY titleChanged)

public:
    explicit FileHeader(QObject *parent = 0);


};

#endif // FILE_HEADER_H
