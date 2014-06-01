#ifndef STATS_H
#define STATS_H

#include <QString>
#include <QVariantList>
#include <QObject>

class Stats : public QObject {
    Q_OBJECT

public:
    Stats();

    Q_INVOKABLE QVariantList getLanguageXgrams(int length, int places, QString language);

    Q_INVOKABLE double getFrequency(QString xgram, QString language);

private:
    QMap<QString, QMap<int, QList<QPair<QString, double> > > > m_orderedXgrams;
    QMap<QString, QMap<QString, double> > m_xgramFrequencies;
};

#endif // STATS_H
