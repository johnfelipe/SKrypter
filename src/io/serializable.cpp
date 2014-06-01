#include "serializable.h"

#include <QVariant>
#include <QMetaObject>
#include <QMetaProperty>
#include <QDebug>

Serializable::Serializable(QObject *parent) : QObject(parent) {}

QDataStream &operator<<(QDataStream &dataStream, const Serializable &serializable) {
    for (int i=0; i<serializable.metaObject()->propertyCount(); i++) {
        if (serializable.metaObject()->property(i).isStored(&serializable)) {
#if TEACHER_PROGRAM
            QString name = serializable.metaObject()->property(i).name();
            if (name.startsWith("student") || name.startsWith("hidden")) {
                dataStream << QVariant();
            }
            else {
                dataStream << serializable.metaObject()->property(i).read(&serializable);
            }
#else
            dataStream << serializable.metaObject()->property(i).read(&serializable);
#endif
        }
    }
    return dataStream;
}

QDataStream &operator>>(QDataStream &dataStream, Serializable &serializable) {
    QVariant tmp;
    for (int i=0; i<serializable.metaObject()->propertyCount(); i++) {
        if (serializable.metaObject()->property(i).isStored(&serializable)) {
            dataStream >> tmp;
            if (tmp.isValid()) {
                serializable.metaObject()->property(i).write(&serializable, tmp);
            }
        }
    }
    return dataStream;
}
