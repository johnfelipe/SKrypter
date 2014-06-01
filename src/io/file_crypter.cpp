#include "file_crypter.h"

#include <QFile>
#include <QBuffer>
#include <QDebug>

// NEVER change this password, or all saved exercises will get unreadable!
static const quint64 password = Q_UINT64_C(0x443f702940687e56);

FileCrypter::FileCrypter()
    : m_simpleCrypt(password)
{
    m_simpleCrypt.setCompressionMode(SimpleCrypt::CompressionAlways);
    m_simpleCrypt.setIntegrityProtectionMode(SimpleCrypt::ProtectionHash);

    m_dataStream.setVersion(QDataStream::Qt_5_2);
}

QDataStream* FileCrypter::getReadStream(QString fileName) {
    if (!QFile::exists(fileName)) {
        qWarning() << "File " << fileName << " does not exist!";
        return NULL;
    }

    QFile file(fileName);
    file.open(QIODevice::ReadOnly);

    // Possible optimization by not decrypting everything at once
    m_byteArray = m_simpleCrypt.decryptToByteArray(file.readAll());
    if (!(m_simpleCrypt.lastError() == SimpleCrypt::ErrorNoError)) {
        qWarning() << "File is corrupt, could not decrypt";
        return NULL;
    }
    file.close();

    m_buffer.setBuffer(&m_byteArray);
    m_buffer.open(QIODevice::ReadOnly);
    m_dataStream.setDevice(&m_buffer);

    return &m_dataStream;
}

QDataStream *FileCrypter::getWriteStream() {
    m_buffer.open(QIODevice::WriteOnly);
    m_dataStream.setDevice(&m_buffer);

    return &m_dataStream;
}

void FileCrypter::closeReadStream() {
    m_buffer.close();
}

void FileCrypter::closeWriteStream(QString filename) {
    QByteArray cipherText = m_simpleCrypt.encryptToByteArray(m_buffer.data());
    if (m_simpleCrypt.lastError() != SimpleCrypt::ErrorNoError) {
        qWarning() << "Could not write to file '" << filename << "'";
        return;
    }

    QFile file(filename);
    file.open(QIODevice::WriteOnly);
    file.write(cipherText);
    file.close();
    m_buffer.close();
}
