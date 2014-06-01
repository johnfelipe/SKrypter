#ifndef CALCULATIONS_H
#define CALCULATIONS_H

#include <vector>
#include <QObject>
#include <QVariant>

class Calculations : public QObject {
    Q_OBJECT

public:
    /**
     * @brief Calculations::calculateKasiskiXGrams
     * Calculates the most frequent xgrams contained in a text for different xgram lengths (from fromLengthj
     * to toLength, inclusive). Removes redundant xgrams. Details in the comments in the implementation.
     * @param text text to be analyzed
     * @param fromLength the minimum length of xgrams that should be returned
     * @param toLength the maximum length of xgrams that should be returned
     * @param xMostFrequent the maximum amount of xgrams per length to return
     * @return a QVariantList that can be used by QML containing the x most frequent xgrams.
     * This is an array of toLength - fromLength + 1 many subarrays. Each subarray contains alternating
     * the xgrams and counts of the most frequent xgrams for that length.
     * For example: [["ABCD", 3, "GILK", 2], ["QTQ", 6, "QTA", 3]]
     */
    Q_INVOKABLE QVariantList calculateKasiskiXGrams(QString text, unsigned int from, unsigned int to, unsigned int xMostFrequent);

    /**
     * @brief Calculations::calculateRelativeXGrams This function calculates
     * at most the xMostFrequent xgrams of xGramLength in the given text. The result is
     * given in the form of relative percentages.
     * The function first creates a map of all xgrams, then it loops over that map until
     * the xMostFrequent xgrams are found in any order(or less if there are not
     * xMostFrequent entries). In the last step the xMostFrequent xgrams are
     * ordered and returned.
     * @param text the text to analyze
     * @param xGramLength the length of the xgram to analyze
     * @param xMostFrequent the maximum number of xgrams to be returned
     * @return the relative frequencies of the xmost frequent xgrams of length xGramLength
     */
    Q_INVOKABLE QVariantList calculateRelativeXGrams(QString text, unsigned int xGramLength, unsigned int xMostFrequent);

    /**
     * @brief Calculations::calculateFrequencies This function calculates the
     * relative frequencies of every alpha character in the given text
     * @param text The text to analyze
     * @return a vector with all relative frequencies for each letter
     */
    Q_INVOKABLE std::vector<double> calculateFrequencies(QString text);

    /**
     * @brief Calculations::friedmanTest This function performs a Friedman Test. It calculates
     * the Friedman Characteristic for each key length between fromKey and toKey (inclusive)
     * based on FC(m)(t).
     * @param text The text to be analyzed
     * @param fromKey This is the lowest value we wish to analyse
     * @param toKey This is the highest value we wish to analyze
     * @return a QVarianList containing the FC(m)(t) for all m between fromKey and toKey
     */
    Q_INVOKABLE QVariantList friedmanTest(QString text, int fromKey, int toKey);

    /**
     * @brief Calculations::calculateFC This function calculates FC(t)
     * @param text The text to analzye
     * @return FC(t)
     */
    Q_INVOKABLE double calculateFC(QString text);

    /**
     * @brief Calculations::sinkovTest Calculates the Sinkov test on the text
     * @param text The text to analyze
     * @param Kd  The value of the Friedman Characteristic of the language
     * @param Kg  The value of the FC of a uniform distribution
     * @return the Sinkov test
     */
    Q_INVOKABLE double sinkovTest(QString text, double Kd, double Kg);

    Q_INVOKABLE void createXGramMapHelper(unsigned int xGramLength, QString text);
private:
    /**
     * @brief Calculations::createXGramMap This function creates a map where the key is the
     * xgram and the value is the number of occurrences of that xgram.
     * @param xGramLength the length of xgrams to be added to the map
     * @param text the text to analyze
     * @return map with all xgrams and their occurrences
     */
    QMap<QString, int> createXGramMap(unsigned int xGramLength, QString text);

};

#endif // CALCULATIONS_H
