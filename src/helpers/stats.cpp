#include "stats.h"

#include <QDebug>
#include <QFile>

QVariantList Stats::getLanguageXgrams(int length, int places, QString language) {
    QVariantList result;
    for (int i=0; i<places; i++) {
        result.push_back(m_orderedXgrams[language][length][i].first);
        result.push_back(m_orderedXgrams[language][length][i].second);
    }

    return result;
}

double Stats::getFrequency(QString xgram, QString language) {
    //returns 0 if the xgram does not exist, because the QMap
    //returns a default value which for int is 0
    return m_xgramFrequencies[language][xgram.toLower()];
}

Stats::Stats() {
    //Fill m_orderedXgrams
    QFile file(":/src/helpers/stats.txt");

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "ERROR: Could not open logfile " << file.fileName();
    }

    while (!file.atEnd()) {
        QString line = file.readLine().trimmed();
        if (line.startsWith("//") || line.isEmpty()) {
            continue;
        }

        QStringList splitLine = line.split(",");

        QString xgram = splitLine[1].trimmed();
        m_orderedXgrams[splitLine[0].trimmed()][xgram.length()].push_back(qMakePair(xgram, splitLine[2].trimmed().toDouble()));
    }

    //Fill m_xgramFrequencies
    QString languages[] = {"de", "en", "es", "fr", "it"};

    //loop through all languages
    for (int i=0; i< m_orderedXgrams.count(); i++) {
        QString currentLanguage = languages[i];

        //loop through all lengths
        for (int j=1; j< m_orderedXgrams[currentLanguage].count()+1; j++) {

            //loop through all xgrams
            for (int k=0; k < m_orderedXgrams[currentLanguage][j].length(); k++) {
                QString currentXgram = m_orderedXgrams[currentLanguage][j][k].first;
                double currentPercentage = m_orderedXgrams[currentLanguage][j][k].second;

                m_xgramFrequencies[currentLanguage][currentXgram] = currentPercentage;

            }

        }
    }
}
