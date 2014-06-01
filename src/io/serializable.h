#ifndef SERIALIZABLE_H
#define SERIALIZABLE_H

#include <QObject>
#include <QDataStream>

/**
 * @brief The Serializable class
 * Class used to serialize and deserialize objects
 * (in our case Exercise objects)
 */
class Serializable : public QObject {
    Q_OBJECT

public:
    explicit Serializable(QObject *parent = 0);
};

/**
 * @brief operator << definition of serialization operator
 * @param dataStream datastream to serialize into
 * @param serializable object to serialize
 * @return datastream with serialized object
 */
QDataStream &operator<<(QDataStream &dataStream, const Serializable &serializable);

/**
 * @brief operator >> definition of deserialization operator
 * @param dataStream datastream to deserialize from
 * @param serializable object to deserialize
 * @return datastream with deserialized object
 */
QDataStream &operator>>(QDataStream &dataStream, Serializable &serializable) ;

#endif // SERIALIZABLE_H
