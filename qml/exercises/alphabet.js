.pragma library

.import "../common/Globals.js" as Globals
.import CCode 1.0 as CCode

/******************Custom String Functions *****************/

/**
 * Conversion function. The function converts a charCode to an
 * index position in an array. The array has 26 positions with A being at 0,
 * B at 1 and so on. The function allows for converting upper and lowercase letters
 * to the correct array position. It returns -1 if the charCode does not represent
 * a letter
 *
 * @param  charCode  The charCode that needs to be shifted
 * @return  the position of the charCode in the array or -1
 */
function charCodeToIndex(charCode) {
    var index = -1;
    if (charCode >= 65 && charCode <= 90) {
        index = charCode-65;
    }
    else if (charCode >= 97 && charCode <= 122){
        index = charCode - 97;
    }
    return index;
}

/**
 * Conversion function. The function converts an array index to the correct
 * UPPERCASE Letter.
 *
 * @param  index  The index that needs to be translated
 * @return  the upperCase letter of the CharCode
 */
function indexToUpperString(index) {
    console.assert(index >= 0 && index < 26, "Index has to be between 0 and 25")
    return String.fromCharCode(index+65);
}

/**
 * Conversion function. The function converts an array index to the correct
 * LOWERCASE Letter.
 *
 * @param  index  The index that needs to be translated
 * @return  the lowerCase letter of the CharCode
 */
function indexToLowerString(index) {
    console.assert(index >= 0 && index < 26, "Index has to be between 0 and 25")
    return String.fromCharCode(index+97);
}

/**
  * finds out whether a given charCode is upper case
  *
  * @param charCode  the charCode
  * @return bool indicating if is upper case
  */
function isUpperCase(charCode) {
    return charCode >= 65 && charCode <= 90;
}

/**
  * Converts a string key to an index key array. If the position of the key is
  * a non letter the index will be set to -1!
  *
  * @param key  the string key
  * @param isEncrypt indicates if we want an encryption key or decryption key
  * @return bool the array key with indexes
  */
function stringKeyToIndexKey(key, isEncrypt) {
    var keys = []
    for (var i=0; i<key.length; i++) {
        var shift = charCodeToIndex(key.charCodeAt(i))
        if (!isEncrypt && shift !== -1) {
            shift = (26 - shift) % 26;
        }
        keys[i] = shift
    }

    return keys
}

/**
  * Inverts a given Perm key (basically inverts the permutation)
  *
  * @param  key
  * @return  the inverted key
  */
function invertMapping(key) {
    var invKey = []

    for (var i=0; i<key.length; i++) {
        invKey[key[i]] = i
    }

    return invKey
}

/*************************** TEXT FUNCTIONS ****************/


/**
 * Letter shifting function (like in Caesar cipher).
 *
 * @param  text  The text that needs to be shifter
 * @param  key  The value by which the letters need to be shifted
 * @return  the text with all shifted letters
 */
function shiftLetters(text, key) {
    console.assert(key >= 0 && key <= 25, "Key must be between 0 and 25")

    var output = ""
    for (var i=0; i<text.length; i++) {
        var current = text.charCodeAt(i);
        var index = charCodeToIndex(current)

        if (index === -1) {
            output += text[i];
        }
        else {
            if (isUpperCase(current)) {
                output += indexToUpperString((charCodeToIndex(current) + key) % Globals.alphabet_length)
            }
            else {
                output += indexToLowerString((charCodeToIndex(current) + key) % Globals.alphabet_length)
            }
        }
    }
    return output
}

/**
 * Returns string with replaced character at index
 *
 * @param  text  The text to change
 * @param  index  The index to change
 * @param  character  The character to insert
 * @return  the updated string
 */
function updateAtIndex(text, index, character) {
    if (index >= text.length) {
        console.warn("alphabet.js, updateAtIndex index out of bounds")
        return text
    }

    return text.substr(0, index) + character + text.substr(index+character.length);
}

/*************************** TEXT CLEANING FUNCTIONS ****************/

/**
 * This function cleans a given text based on the current alphabet and language settings
 *
 * @param  text The text that has to be cleaned
 * @param  isCase indicates whether lower case is allowed
 * @param  ignoredCharacters is a list of characters to not clean
 * @param  language the desired language
 * @return  the cleaned text
 */
function cleanText(text, isCase, ignoredCharacters, language) {
    if (!isCase) {
        text = text.toUpperCase()
    }

    //clean text language specific
    if (language === "de") {
        text = cleanGerman(text, isCase)
    }
    else if (language === "es") {
        text = cleanSpanish(text, isCase)
    }
    else if (language === "fr") {
        text = cleanFrench(text, isCase)
    }
    else if (language === "it") {
        text = cleanItalian(text, isCase)
    }
    //english needs no additional cleaning


    //check for special characters that should simply be removed
    var cleanedText = ""
    for (var i=0; i<text.length; i++) {
        var currentIndex = charCodeToIndex(text[i].charCodeAt(0))

        if (currentIndex !== -1) {
            cleanedText += text[i]
            continue
        }

        for (var j=0; j<ignoredCharacters.length; j++) {
            if (text[i] === ignoredCharacters[j]) {
                cleanedText += text[i]
                continue
            }
        }
    }

    return cleanedText
}

function cleanSpanish(text, isCase) {
    if (isCase) {
        text = text.replace(/á/g, "a")
        text = text.replace(/é/g, "e")
        text = text.replace(/í/g, "i")
        text = text.replace(/ñ/g, "n")
        text = text.replace(/ó/g, "o")
        text = text.replace(/[úü]/g, "u")
    }

    text = text.replace(/Á/g, "A")
    text = text.replace(/É/g, "E")
    text = text.replace(/Í/g, "I")
    text = text.replace(/Ñ/g, "N")
    text = text.replace(/Ó/g, "O")
    text = text.replace(/[ÚÜ]/g, "U")


    return text
}

function cleanGerman(text, isCase) {
    if (isCase) {
        text = text.replace(/ä/g, "ae")
        text = text.replace(/ö/g, "oe")
        text = text.replace(/ü/g, "ue")
        text = text.replace(/ß/g, "ss")

        text = text.replace(/Ä/g, "Ae")
        text = text.replace(/Ö/g, "Oe")
        text = text.replace(/Ü/g, "Ue")
    }

    text = text.replace(/Ä/g, "AE")
    text = text.replace(/Ö/g, "OE")
    text = text.replace(/Ü/g, "UE")
    text = text.replace(/ß/g, "SS")

    return text
}

function cleanFrench(text, isCase) {
    if (isCase) {
        text = text.replace(/[àâ]/g, "a")
        text = text.replace(/æ/g, "ae")
        text = text.replace(/ç/g, "c")
        text = text.replace(/[éèêë]/g, "e")
        text = text.replace(/[îï]/g, "i")
        text = text.replace(/ô/g, "o")
        text = text.replace(/œ/g, "oe")
        text = text.replace(/[ùûü]/g, "u")
        text = text.replace(/ÿ/g, "y")
    }

    text = text.replace(/[ÀÂ]/g, "A")
    text = text.replace(/Æ/g, "AE")
    text = text.replace(/Ç/g, "C")
    text = text.replace(/[ÉÈÊË]/g, "E")
    text = text.replace(/[ÎÏ]/g, "I")
    text = text.replace(/Ô/g, "O")
    text = text.replace(/Œ/g, "OE")
    text = text.replace(/[ÙÛÜ]/g, "U")
    text = text.replace(/Ÿ/g, "Y")

    return text
}

function cleanItalian(text, isCase) {
    if (isCase) {
        text = text.replace(/[à]/g, "a")
        text = text.replace(/[éè]/g, "e")
        text = text.replace(/[îìí]/g, "i")
        text = text.replace(/[òó]/g, "o")
        text = text.replace(/[ùú]/g, "u")
    }

    text = text.replace(/[À]/g, "A")
    text = text.replace(/[ÉÈ]/g, "E")
    text = text.replace(/[ÎÌÍ]/g, "I")
    text = text.replace(/[ÓÒ]/g, "O")
    text = text.replace(/[ÙÚ]/g, "U")

    return text
}


/**
 * This function colors partial texts for partially given texts in the form of "___X__"
 * if the partial solution is a character we check if the character of the text is the same
 * and color it green, else it is colored red
 *
 * @param  text The text to be colored
 * @param  solution the partial solution
 * @return  the colored text
 */
function correctText(text, solution) {
    var result = ""
    for (var i=0; i<text.length; i++) {
        if (solution[i] !== "_") {
            if (text[i] === solution[i]) {
                result += "<font color=" + Globals.green3 +">" + solution[i] + "</font>";
            }
            else {
                result += "<font color=" + Globals.blue3 +">" + solution[i] + "</font>";
            }
        }
        else {
            result += text[i];
        }
    }
    return result;
}

/**
 * This function is responsible for marking the textToCheck based on the
 * solution with appropriate feedback for the user. The function
 * should only be used to check user input. If the user has entered a
 * wrong character it is marked red. If characters are missing red dots
 * are added to the end of the text. If all is correct, the text will be
 * marked green.
 *
 * @param  textToCheck The text that should be corrected
 * @param  solution The correct solution text
 * @return  textToCheck marked based on solution
 */
function markText(textToCheck, solution) {
    var allCorrect = textToCheck.length === solution.length

    var returnText = ""
    for (var i=0; i<textToCheck.length; i++)
    {
        if (textToCheck[i] === solution[i]) {
            returnText += textToCheck[i]
        }
        else {
            allCorrect = false
            returnText += "<font color=" + Globals.orange4 + ">" + textToCheck[i] + "</font>"
        }
    }

    if (textToCheck.length < solution.length) {
        returnText += "<font color=" + Globals.orange4 + ">…</font>"
    }

    if (allCorrect) {
        returnText = "<font color=" + Globals.green4 + ">" + returnText + "</font>"
    }

    return returnText
}


/*************************** SINGLE LETTERS FREQUENCY FUNCTIONS ****************/


/**
 * This function fills a ListModel with an alphabet. Additionally
 * each letter is assigned a percentage representing the relative
 * frequency of this letter. If fillZero is true it means that the
 * relative frequencies are not know yet and thus filled with zeroes.
 * If fillZero is true we assume that the text is in German and the
 * percentages are automatically filled with the relative frequencies
 * of letters in German texts.
 *
 * @param  model  The ListModel to be filled
 * @param  fillZero boolean indicating if percentages should be initialized to zero
 */
function createOrUpdateAlphabet(model, fillZero, language) {
    model.clear()
    for (var i = 0; i < Globals.alphabet_length; i++) {
        var letter = indexToUpperString(i);
        if (fillZero) {
            model.append({"letter":letter, "percentage": 0});
        }
        else {
            model.append({"letter":letter, "percentage": CCode.Stats.getFrequency(letter, language)});
        }
    }
}

/**
 * This is a sort functions that sorts the passed ListModel depending
 * on the value of sortByLetters either by letters or percentages.
 *
 * @param  model  The id of the ListModel to be sorted
 * @param  sortByLetters boolean indicating if the function should sort
            by letters or by percentages
 */
function sortModel(model, sortByLetters) {
    var stats = []

    for (var i=0; i<model.count; i++) {
        stats[i] = {"letter":model.get(i).letter, "percentage": model.get(i).percentage}
    }

    //custom sort functions
    if (sortByLetters) {
        stats.sort(function(a, b) {
            return (a.letter.localeCompare(b.letter));
        });
    }
    else {
        stats.sort(function(a, b) {
            if(a.percentage === b.percentage) {
                return a.letter.localeCompare(b.letter)
            }

            return (b.percentage - a.percentage);
        });
    }

    for (var i=0; i<stats.length; i++) {
        model.set(i, stats[i]);
    }
}

/**
 * This is a sort functions that sorts the passed ListModel randomly using the
 * Fisher Yates algorithm.
 *
 * @param  model  The id of the ListModel to be sorted
 */
function sortModelRandomly(model) {
    var sortedModel = []

    for (var i=0; i<model.count; i++) {
        sortedModel[i] = {"letter":model.get(i).letter, "percentage": model.get(i).percentage}
    }

    //sort
    //algorithm taken from http://bost.ocks.org/mike/shuffle/
    var length = sortedModel.length
    var temp, randomPos;

    // While there remain elements to shuffle…
    while (length) {
        // Pick a remaining element…
        randomPos = Math.floor(Math.random() * length--);

        // And swap it with the current element.
        temp = sortedModel[length];
        sortedModel[length] = sortedModel[randomPos];
        sortedModel[randomPos] = temp;
    }

    for (var i=0; i<sortedModel.length; i++) {
        model.set(i, sortedModel[i]);
    }
}



/**
 * This function determines the height of the percentage bar for the letter
 * at position pos depending on the value of the relative frequency of this
 * letter and the highest relative frequency of any letter.
 *
 * @param  model        The model containing the data
 * @param  pos          position of the current letter
 * @param  base_height  the maximum amount of space in the gui
 */
function percentageToHeight(model, pos, base_height) {
    var maxHeight = 0;

    if (model.count <= pos || pos < 0) {
        return maxHeight;
    }

    for (var i=0; i<model.count; i++) {
        var newHeight = model.get(i).percentage;
        if (newHeight>maxHeight) {
            maxHeight = newHeight;
        }
    }

    var myHeight = model.get(pos).percentage;

    return (maxHeight == 0) ?  0 : base_height*myHeight/maxHeight
}


/**
 * This function recalculates all the relative frequencies of each letter. The
 * algorithm first counts all occurrences of each letter and then
 * divides this number for each letter by the total number of valid
 * letters (spaces, commas and so on are not counted).
 *
 * @param  geheimtext  The secret text
 * @param  model The model that should be updated.
 * @param  isRelative indicates whether the occurrences should be absolute or relative
 */
function updateStats(geheimtext, model, isRelative) {
    if (model.count === 0) {
        return;
    }

    var numberOfLetters = []

    for (var i=0; i<model.count; i++) {
        numberOfLetters[i]=0;
    }

    var totalLetters = 0;

    for (var i=0; i < geheimtext.length; i++) {
        var current = geheimtext.charCodeAt(i);
        var index = charCodeToIndex(current);
        if (index !== -1) {
            numberOfLetters[index]++;
            totalLetters++
        }
    }

    for (var i=0; i<model.count; i++) {
        var curLetter = model.get(i).letter;
        var curPos = charCodeToIndex(curLetter.charCodeAt(0));
        if (isRelative) {
            model.setProperty(i, "percentage", (totalLetters > 0) ? (numberOfLetters[curPos]/totalLetters) * 100 : 0);

        }
        else {
            model.setProperty(i, "percentage", numberOfLetters[curPos]);
        }

    }
}

/*************************** XGRAM FUNCTIONS ****************/

/**
 * This function turns an array into a ListModel usable by QML
 *
 * @param  model the qml listmodel
 * @param  list the array with the information
 */
function createXGramModel(model, list) {
    model.clear()

    var j = 0
    for (var i=0; i<list.length; i=i+2) {
        model.set(j, {"xgram": list[i], "percentage" : list[i+1]})
        j++
    }
}

/**
  * This function creates a xGram ListModel with the frequencies of a language
  *
  * @param model to be initialized
  * @param length 2=bigram, 3=trigrams
  * @param places number of desired entries
  * @param language desired languager (e.g. "en", "de", ...)
  */
function getLanguageXGram(model, length, places, language) {
    model.clear()
    // Returns list in format ["ab", 3.88, "ef", 2.86, "ik", 1.55, ...]
    var bigramFrequencyList = CCode.Stats.getLanguageXgrams(length, places, language)

    console.assert(places*2 === bigramFrequencyList.length, "Not enough items in stats available")

    for (var i = 0; i < bigramFrequencyList.length; i += 2) {
        model.append({"xgram":bigramFrequencyList[i].toUpperCase(), "percentage": bigramFrequencyList[i+1]})
    }
}

/**
  * This function marks the given xgram in the text
  *
  * @param  text the text to be marked
  * @param  xgram the string to be marked
  * @return the marked text
  */
function markXGrams(text, xgram) {
    text = text.replace(new RegExp("(" + xgram + ")", "gi"), "<font color=" + Globals.green4 + "><i><b>$1</i></b></font>")

    return text
}

/*************************** MODEL FUNCTIONS ****************/

/**
 * This function shifts the given model by pos positions.
 *
 * @param  model  The id of the ListModel to be shifted
 * @param  pos number of positions. Should be in range
 * (-model.count, model.count), excluding borders
 */
function shiftModel(model, pos) {
    console.assert(pos > -model.count && pos < model.count, "Should be in range (-model.count, model.count), excluding borders")

    var stats = []
    for (var i=0; i<model.count; i++) {
        stats[i] = {"letter":model.get(i).letter, "percentage": model.get(i).percentage}
    }
    for (var i=0; i<stats.length; i++) {
        model.set(i, stats[(i-pos+model.count)%model.count]);
    }
}

/**
 * This function shifts the given model to the given position
 *
 * @param  model  The id of the ListModel to be shifted
 * @param  pos absolute number of the new position. Should be in range (0, model.count-1), including borders
 */
function shiftModelToLetter(model, pos) {
    console.assert(pos >= 0 && pos <= model.count-1, "Should be in range (0, model.count-1), including borders")

    var stats = []
    for (var i=0; i<model.count; i++) {
        stats[i] = {"letter":model.get(i).letter, "percentage": model.get(i).percentage}
    }
    for (var i=0; i<stats.length; i++) {
        model.set((charCodeToIndex(stats[i].letter.charCodeAt(0))-pos+model.count)%model.count, stats[i])
    }
}

/**
 * This function marks the letter in the repeater
 *
 * @param  model  the model containing all letters
 * @param  letter the concrete letter to be marked
 * @param  repeater  the actual place that needs to be marked
 */
function markSelectedLetter(model, letter, repeater) {
    var pos = -1
    var modelLetters = ""
    letter = letter.toUpperCase()
    for (var i=0; i<model.count; i++) {
        var model_letter = model.get(i).letter;
        modelLetters += model_letter
        if (model_letter === letter) {
            pos = i
            break
        }
    }

    repeater.itemAt(i).markedBorder = true
}

/**
 * This function unmarks all letter in the repeater
 *
 * @param  repeater  to be unmarked
 */
function unmarkAll(repeater) {
    for (var i=0; i<repeater.count; i++) {
        repeater.itemAt(i).markedBorder = false
    }
}


/*
//SPEED TESTING
function calculateXGramMap(text, xGramLength) {
    var map = {}

    //ensure no endless loop
    if (text.length < xGramLength) {
        return map;
    }

    //calculate the xgrams (key is the xgrams, value the number of occurrences)
    for (var i = 0; i < text.length - xGramLength + 1; i++) {
        //get xgrams
        var tmpXGram = text.substring(i, i+xGramLength).toUpperCase();

        if (tmpXGram.indexOf(" ") === -1) {

            if (map[tmpXGram]) {
                map[tmpXGram]++;
            }
            else {
                map[tmpXGram] = 1;
            }
        }
    }

    return map;
}
*/

