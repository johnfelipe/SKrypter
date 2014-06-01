#include "calculations.h"

#include <QString>
#include <QMap>
#include <QDebug>
#include <QTextStream>

struct Entry {
    Entry() : count(-1) {
    }

    Entry(QString newXgram, int newCount)
        : xgram(newXgram)
        , count(newCount) {
    }

    QString xgram;
    int count;
};

/**
 * @brief entry_sorter helper function to sort an array of Entry structs
 * @param lhs the left hand value
 * @param rhs the right hand value
 * @return
 */
bool entry_sorter(Entry const& lhs, Entry const& rhs) {
    if (lhs.count != rhs.count) {
        return rhs.count < lhs.count;
    }
    else {
        return lhs.xgram < rhs.xgram;
    }
}

QMap<QString, int> Calculations::createXGramMap(unsigned int xGramLength, QString text) {
    QMap<QString, int> map;

    //ensure no endless loop
    if ((unsigned) text.length() < xGramLength) {
        return map;
    }

    //calculate the xgrams (key is the xgrams, value the number of occurrences)
    for (unsigned int i = 0; i < text.length() - xGramLength + 1; i++) {
        //get xgrams
        QString tmpXGram = text.mid(i, xGramLength).toUpper();

        if (tmpXGram.indexOf(" ") == -1) {

            if (map.contains(tmpXGram)) {
                map[tmpXGram]++;
            }
            else {
                map[tmpXGram] = 1;
            }
        }
    }

    return map;
}

QVariantList Calculations::calculateKasiskiXGrams(QString text, unsigned int fromLength, unsigned int toLength, unsigned int xMostFrequent) {
    text = text.toUpper();
    QVariantList result;

    /* List of all xgrams that would be redundant. If we already added "ABCD" with count 3 to the result,
     * and fromLenght is 2, then the xgrams "ABC", "BCD", "AB", "BC", and "CD", all with a count of 3,
     * are added to this list. Basically these are all the redundant xgrams for a Kasiski Test. */
    QMap<QString, int> accountedForMap;

    // For each length between fromLength and toLength we find the xMostFrequent xgrams that are not redundant.
    // We start with the longest ones to be able to filter out the redundant xgrams.
    for (unsigned int length = toLength; length >= fromLength; length--) {
        QMap<QString, int> map = createXGramMap(length, text);

        QMapIterator<QString, int> iterator(map);

        //if we are only interested in absolute counts we are only interested in all xgrams that appear more than once!
        //in this case we loop through all xgrams and add all entries with count >1 to a new array.
        std::vector< Entry > moreThanOnceEntries;

        while (iterator.hasNext()) {
            iterator.next();
            // Sort out current xgram if it is in the accountedForMap with a >= count, and thus redundant.
            if (iterator.value() > 1 && (!accountedForMap.contains(iterator.key()) || accountedForMap[iterator.key()] < iterator.value())) {
                moreThanOnceEntries.push_back(Entry(iterator.key(), iterator.value()));
            }
        }

        //perform actual sorting of all elements
        std::sort(moreThanOnceEntries.begin(), moreThanOnceEntries.end(), &entry_sorter);

        QVariantList sortedXGrams;

        unsigned int numberOfElements = std::min((unsigned int) moreThanOnceEntries.size(), xMostFrequent);

        // Loop through all the elements that will be returned
        for (unsigned int i=0; i<numberOfElements; i++) {
            // Add all substrings of length >= fromLength to the accountedForMap
            for (unsigned int sublength = length-1; sublength >= fromLength; sublength--) {
                for (unsigned int offset = 0; offset <= length - sublength; offset++) {
                    QString substring = moreThanOnceEntries[i].xgram.mid(offset, sublength);

                    // Add or update entry in map
                    if(accountedForMap.contains(substring)) {
                        accountedForMap[substring] = std::max(moreThanOnceEntries[i].count, accountedForMap[substring]);
                    }
                    else {
                        accountedForMap[substring] = moreThanOnceEntries[i].count;
                    }
                }
            }

            sortedXGrams << moreThanOnceEntries[i].xgram << moreThanOnceEntries[i].count;
        }

        result.push_back(sortedXGrams);
    }

    return result;
}

QVariantList Calculations::calculateRelativeXGrams(QString text, unsigned int xGramLength, unsigned int xMostFrequent) {
    //Map to store found xgrams
    QMap<QString, int> map = createXGramMap(xGramLength, text);

    QMapIterator<QString, int> iterator(map);

    //entries added to the mostFrequentEntries array
    unsigned int addedEntries = 0;

    //array of structs that will contain the xMostFrequent xgrams (in any order!)
    std::vector<Entry> mostFrequentEntries(xMostFrequent);

    //loop over all xgrams in the map
    while (iterator.hasNext()) {
        iterator.next();
        if (addedEntries < xMostFrequent) {
            //we can simply add the entry to the array
            mostFrequentEntries[addedEntries] = Entry(iterator.key(), iterator.value());
            addedEntries++;
        }
        else {
            //find the current xgram with the lowest count
            int smallest_count = mostFrequentEntries[0].count;
            int smallest_index = 0;
            for (unsigned int i = 1; i < xMostFrequent; i++) {
                if (mostFrequentEntries[i].count < smallest_count) {
                    smallest_count = mostFrequentEntries[i].count;
                    smallest_index = i;
                }
            }
            if (smallest_count  < iterator.value()) {
                //if the smallest found index is smaller than the current value we replace it
                mostFrequentEntries[smallest_index].count = iterator.value();
                mostFrequentEntries[smallest_index].xgram = iterator.key();
            }
        }
    }

    //perform actual sorting of addedEntries manyElements
    std::sort(mostFrequentEntries.begin(), mostFrequentEntries.begin() + addedEntries, &entry_sorter);

    QVariantList sortedXGrams;
    float numberOfXGrams = (float) text.length() - xGramLength + 1;
    for (unsigned int i=0; i<addedEntries; i++) {
        float percentage = mostFrequentEntries[i].count*100/numberOfXGrams;
        sortedXGrams << mostFrequentEntries[i].xgram << percentage;
    }

    return sortedXGrams;
}

std::vector<double> Calculations::calculateFrequencies(QString text) {
    std::vector<double> result(26, 0);

    if (text.length() <= 0) {
        //no text to analyze, everything has frequency of 0
        return result;
    }
    else {
        int total = 0;

        for (int i=0; i<text.length(); i++) {
            QChar currentChar = text[i];
            if (currentChar.isLetter()) {
                int position = currentChar.toLower().toLatin1() - 'a';
                result[position]++;
                total++;
            }
        }

        for (unsigned i=0; i<result.size(); i++) {
            result[i] /= total;
        }

        return result;
    }
}

QVariantList Calculations::friedmanTest(QString text, int fromKey, int toKey) {
    QVariantList result;

    for (int keyLength=fromKey; keyLength<=toKey; keyLength++) {
        std::vector<QString> subTexts(keyLength);

        int counter = 0;
        for (int i=0; i<text.length(); i++) {
            if (text[i].isLetter()) {
                subTexts[counter%keyLength] += text[i];
                counter++;
            }
        }

        if (counter < keyLength) {
            qWarning("Calculations::friedmanTest keyLength is longer than number of letters in text!");
        }

        double sum = 0;
        for(int i=0; i<keyLength; i++) {
            sum += calculateFC(subTexts[i]);
        }
        result.append(sum/keyLength);
    }

    return result;
}

double Calculations::calculateFC(QString text) {
    if (text.length() <= 0) {
        //agreed by email of 3.3.2014
        return 1.0;
    }
    else {
        std::vector<double> frequencies = calculateFrequencies(text);

        double sum = 0;
        for (unsigned i=0; i<frequencies.size(); i++) {
            sum += frequencies[i]*frequencies[i];
        }
        return sum;
    }
}

double Calculations::sinkovTest(QString text, double Kd, double Kg) {
    double FC = calculateFC(text);

    return (Kd - Kg) / (FC - Kg);
}

void Calculations::createXGramMapHelper(unsigned int xGramLength, QString text)
{
    createXGramMap(xGramLength, text);
}
