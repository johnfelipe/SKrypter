#ifndef FILE_CRYPTER_H
#define FILE_CRYPTER_H

#include <QDataStream>
#include <QBuffer>

#include "simplecrypt.h"

/**
 * @brief The FileCrypter class
 * The file cryter class is responsible for both reading
 * and writing encrypted files using simplecrypt.
 */
class FileCrypter {

public:
    FileCrypter();

    /**
     * @brief getReadStream returns a stream for reading the
     * indicated file
     * @param fileName the file to be read
     * @return stream
     */
    QDataStream *getReadStream(QString fileName);

    /**
     * @brief getWriteStream returns a write stream
     * @return write stream
     */
    QDataStream *getWriteStream();

    /**
     * @brief closeReadStream will simply close the read stream
     * correctly
     */
    void closeReadStream();

    /**
     * @brief closeWriteStream will first write the information
     * to the indicated file and then close the stream correctly
     * @param filename
     */
    void closeWriteStream(QString filename);

private:
    QDataStream m_dataStream;
    QBuffer m_buffer;
    QByteArray m_byteArray;

    SimpleCrypt m_simpleCrypt;
};

#endif // FILE_CRYPTER_H
