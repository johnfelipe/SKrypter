.import "../alphabet.js" as Alphabet
.import "../../common/Globals.js" as Globals

/**
 * This function either encrypts or decrypts text based on the mapping that
 * is passed (if parts of the passed mapping are -1 it means they are unassigned
 * at this moment, used for ButtonLocker)
 *
 * @param  text_input The text that has to be crypted
 * @param  mapping represents the key
 * @return  the crypted text
 */
function crypt(text_input, mapping) {
    var text_output = "";
    for (var i = 0; i < text_input.length; i++) {
        var currentCharCode = text_input.charCodeAt(i);

        var index = Alphabet.charCodeToIndex(currentCharCode);

        if (index >= 0) {
            if (mapping[index] === -1) {
                //mapping not locked yet
                text_output += "_";
            }
            else {
                if (Alphabet.isUpperCase(currentCharCode)) {
                    text_output += Alphabet.indexToUpperString(mapping[index]);
                } else {
                    text_output += Alphabet.indexToLowerString(mapping[index]);
                }
            }
        }

        else {
            text_output += text_input[i];
        }
    }

    return text_output;
}

/**
 * This function checks whether a plain and cipher text could have been
 * en or decrypted with the given key. It is very relevant whether the
 * isEncrypt parameter is set to true or not as it has to match the passed model!
 *
 * @param  plaintext The plaintext
 * @param  ciphertext The ciphertext
 * @param  model contains the key
 * @param  isEncrypt says whether to encrypt or decrypt
 * @return bool indicating whether the plaintext can result in the ciphertext
 */
function check(plaintext, ciphertext, model, isEncrypt) {
    var mapping = []

    //create mapping from the model (assumes that at position 0 we have the mapping for letter a
    for (var i=0; i<model.count; i++) {
        mapping [i] = Alphabet.charCodeToIndex(model.get(i).letter.charCodeAt(0))
    }

    if (isEncrypt) {
        return ciphertext === crypt(plaintext, mapping)
    }

    else {
        return plaintext === crypt(ciphertext, mapping)
    }
}

/*************************** CHECK FUNCTIONS ****************/

/**
 * This function checks whether a key is correct or not based on
 * a ciphertext and plaintext
 *
 * @param  model the model containing the key
 * @param  plaintext the plaintext
 * @param  ciphertext the ciphertext
 * @return  bool indicating whether key can be correct or not
 */
function checkKey(model, plaintext, ciphertext) {
    return ciphertext === crypt(plaintext, getSimpleMapping(model))

}

/*************************** MARK FUNCTIONS ****************/

/**
 * This function is responsible for marking either the plain or
 * cipher text with appropriate feedback for the user. The function
 * should only be used to check user input. If the user has entered a
 * wrong character it is marked red. If characters are missing red dots
 * are added to the end of the text. If all is correct, the text will be
 * marked green.
 *
 * @param  plaintext the plaintext
 * @param  ciphertext the ciphertext
 * @param  key the key used for the encryption
 * @param  isEncrypt this bool indicates whether the text was encrypted or decrypted
           if true, this means that the ciphertext needs to be marked!
 * @return  plain- or ciphertext marked based on solution
 */
function markText(plaintext, ciphertext, model, isEncrypt) {
    var mapping = []

    //create mapping from the model (assumes that at position 0 we have the mapping for letter a
    for (var i=0; i<model.count; i++) {
        mapping [i] = Alphabet.charCodeToIndex(model.get(i).letter.charCodeAt(0))
    }

    var solution
    var textToCheck
    if (isEncrypt) {
        solution = crypt(plaintext, mapping)
        textToCheck = ciphertext
    }
    else {
        solution = crypt(ciphertext, mapping)
        textToCheck = plaintext
    }

    return Alphabet.markText(textToCheck, solution)
}

/*************************** KEY FUNCTIONS ****************/

/**
 * This function returns a mapping of plaintext letters to ciphertext letters. Additonally
 * the mapping results in -1 if the current position is not locked. This function is used in
 * the ButtonLocker.
 *
 * @param  text_frequency_model the plaintext model
 * @param  language_frequency_model the reference model
 * @param  locker the model with the lock buttons
 * @return  a mapping
 */
function getMapping(text_frequency_model, language_frequency_model, locker) {
    //create Mapping for locked Letters
    var mapping = []

    for (var i=0; i<locker.count; i++) {
        var locked = locker.itemAt(i).locked;
        var text_frequency_letter = text_frequency_model.get(i).letter;
        var text_frequency_pos = Alphabet.charCodeToIndex(text_frequency_letter.charCodeAt(0));

        var language_frequency_letter = language_frequency_model.get(i).letter;
        var language_frequency_pos = Alphabet.charCodeToIndex(language_frequency_letter.charCodeAt(0));

        if (locked) {
            mapping[text_frequency_pos] = language_frequency_pos;
        }
        else {
            mapping[text_frequency_pos] = -1;
        }
    }

    return mapping
}

/**
 * This function returns a mapping of plaintext letters to ciphertext letters.
 * This function is used in the ButtonLocker.
 *
 * @param  text_frequency_model the plaintext model
 * @param  language_frequency_model the reference model
 * @return  a mapping
 */
function getFullMapping(text_frequency_model, language_frequency_model) {
    //create full mapping
    var mapping = []

    for (var i=0; i<text_frequency_model.count; i++) {
        var text_frequency_letter = text_frequency_model.get(i).letter;
        var text_frequency_pos = Alphabet.charCodeToIndex(text_frequency_letter.charCodeAt(0));

        var language_frequency_letter = language_frequency_model.get(i).letter;
        var language_frequency_pos = Alphabet.charCodeToIndex(language_frequency_letter.charCodeAt(0));

        mapping[text_frequency_pos] = language_frequency_pos;
    }

    return mapping
}

/**
 * Create mapping from the model (assumes that at position 0 we have the mapping for letter a)
 *
 * @param  model the model containing the key
 * @return  mapping (array of shifts)
 */
function getSimpleMapping(model) {
    var mapping = []

    if (model.count === 0) {
        return mapping
    }

    for (var i=0; i<model.count; i++) {
        mapping[i] = Alphabet.charCodeToIndex(model.get(i).letter.charCodeAt(0))
    }

    return mapping
}

/**
 * Creates a mapping without the assumptions of getSimpleMapping
 *
 * @param  model the base model
 * @param  mapping the mapping we want to adapt
 * @return  mapping of mapping mapped to model
 */
function getMappingForUnorderedBase(model, mapping) {
    if (model.count !== mapping.length) {
        console.warn("Perm.js getMappingForUnorderedBase passed model and mapping have different lengths!")
    }

    var newMapping = []

    //loop through all values in the mapping
    for (var i=0; i<mapping.length; i++) {
        var currentLetterIndex = mapping[i]

        //for each value in the mapping find the position in the model
        for (var j=0; j<model.count; j++) {
            if (Alphabet.charCodeToIndex(model.get(j).letter.charCodeAt(0)) === i) {
                newMapping[j] = currentLetterIndex
                break
            }
        }
    }

    return newMapping
}

/**
 * Sets the given mapping in the model
 *
 * @param  model the model that contains the key
 * @param  mapping the mapping to be set
 */
function setMapping(model, mapping) {
    if (mapping.length !== model.count) {
        console.warn("Perm.js, setMapping: mapping does not have the same length as the model: " + mapping)
        return model
    }

    for (var i=0; i<model.count; i++) {
        model.get(i).letter = Alphabet.indexToUpperString(mapping[i])
    }
}

/**
 * Create a string key from the given mapping
 *
 * @param  mapping array of shifts (key)
 * @return  string (key)
 */
function getKeyFromMapping(mapping) {
    var keyString = ""

    for (var i=0; i<mapping.length; i++) {
        keyString += Alphabet.indexToUpperString(mapping[i])
    }

    return keyString
}

/**
 * Create a mapping from a key
 *
 * @param  key string
 * @return  mapping
 */
function getMappingFromKey(key) {
    var mapping = []

    for (var i=0; i<key.length; i++) {
        mapping[i] = Alphabet.charCodeToIndex(key.charCodeAt(i))
    }

    return mapping
}

/**
 * Reads the key from a model
 *
 * @param  model the model
 * @return  key String
 */
function readKeyFromModel(model) {
    var key = ""

    for (var i=0; i<model.count; i++) {
        key += model.get(i).letter
    }

    return key
}

/**
 * Used for Button Locker
 * Creates a string containing a 0 if a certain letter is unlocked and a 1 if the letter is locked
 *
 * @param  repeater contains information about locked positions
 * @param  model  contains information about which letters are at what position
 * @return  string of locked letters
 */
function generateKeyString(repeater, model) {
    var keyArray = []

    for (var i=0; i<repeater.count; i++) {
        if (repeater.itemAt(i).locked) {
            var letterIndex = Alphabet.charCodeToIndex(model.get(i).letter.charCodeAt(0))
            keyArray[letterIndex] = true
        }
    }

    var keyString = ""
    for (var i=0; i<Globals.alphabet_length; i++) {
        if (keyArray[i]) {
            keyString += "1"
        }
        else {
            keyString += "0"
        }
    }

    return keyString

}

/*************************** OTHER FUNCTIONS ****************/

/**
 * This function checks if any letters are currently locked and returns
 * the result.
 *
 * @param  repeater  The Repeater that contains the lock buttons
 * @return  boolean
 */
function hasLockedLetters(repeater) {
    if (repeater.count === 0)
        return;

    var hasLockedLetters = false;
    for (var i=0; i<repeater.count; i++) {
        var locked = repeater.itemAt(i).locked;
        if (locked) {
            hasLockedLetters = true;
            break;
        }
    }
    return hasLockedLetters;
}

/**
  * This functions sets the locked letters in the button_repeater
  * based on the string indicating the lockedPositions
  *
  * @param  repeater  the repeater containing the lock buttons
  * @param  lockedPositions string containing 0 and 1s to indicate if position i is locked or not
  */
function setLockedLetters(repeater, model, lockedPositions) {
    if (repeater.count === 0 || lockedPositions.length !== model.count)
        return;

    for (var i=0; i<model.count; i++) {
        var curLetter = model.get(i).letter
        var curLetterPos = Alphabet.charCodeToIndex(curLetter.charCodeAt(0))
        var isLocked = (lockedPositions[curLetterPos] === "1")
        repeater.itemAt(i).locked = isLocked
    }
}

/** This functions marks all letters that are locked
  * in the given text (used to mark plaintext in teacher mode with
  * letters visible for partial plaintexts)
  *
  * @param  text the text to mark
  * @param  lockedPositions string with 0 and 1 to indicate locked positions
  * @return  the marked text
  */
function markGivenLetters(text, lockedPositions) {
    var markedText = ""

    for (var i=0; i<text.length; i++) {
        var currentIndex = Alphabet.charCodeToIndex(text.charCodeAt(i))
        if (lockedPositions[currentIndex] === "1") {
            markedText += "<font color='#1ca938' style='font-size:20px'><i><b>" + text[i] + "</i></b></font>"
        }
        else {
            markedText += text[i]
        }
    }

    return markedText
}

/** This functions creates a partial plaintext based on the full
  * plaintext and information about which positions are given/locked.
  *
  *
  * @param  text original text
  * @param  lockedPositions string with 0 and 1 to indicate locked positions
  * @return  the marked text
  */
function createPartialPlaintext(text, lockedPositions) {
    var partialText = ""

    for (var i=0; i<text.length; i++) {
        var currentIndex = Alphabet.charCodeToIndex(text.charCodeAt(i))
        if (currentIndex !== -1) {
            if (lockedPositions[currentIndex] === "1") {
                partialText += text[i]
            }
            else {
                partialText += "_"
            }
        }
        else {
            partialText += text[i]
        }
    }
    return partialText
}

/** This function is responsible for calculating the plain text model which is used
  * for displaying the statistics in the Perm teacher mode in the XGramView.
  *
  * @param  model The pt model
  * @param  xgram_model the model containing the xgrams
  * @param  text the text to analyze
  * @param  xGramLength the length of xgrams to find
  */
//function calculatePTModel(model, xgram_model, text, xGramLength) {
//    //clear the old model
//    model.clear()

//    if (text.length < xGramLength) {
//        //we are sure that there ar no xgrams
//        return model
//    }

//    var numberOfXGrams = findNumberOfXgrams(text, xGramLength)
//    if (numberOfXGrams === 0) {
//        //we are sure that there ar no xgrams
//        return model
//    }

//    //loop through all xgrams to be calculated these are all the xgrams in the xgram_model
//    for (var i=0; i<xgram_model.count; i++) {
//        var currentXGram = xgram_model.get(i).xgram

//        var regex = new RegExp(currentXGram,'gi');

//        //find the xgram in the text
//        var foundXGrams = text.match(regex);

//        //setting the count
//        var count = foundXGrams ? foundXGrams.length : 0

//        //appending to the model
//        model.append({"xgram":currentXGram, "percentage": count*100/numberOfXGrams})
//    }
//}

/** This function calculates the total number of xgrams of xgramLength in a given text.
  *
  * @param  text the text to analyze
  * @param  xGramLength the length of xgrams to find
  * @return  the number of xgrams of xgramLength in the text
  */
function findNumberOfXgrams(text, xgramLength) {
    //split text into words
    var wordArray = text.split(" ")

    var count = 0
    for (var i=0; i<wordArray.length; i++) {
        //formula to find number of x grams in current xgram
        var xGramsInCurrent = wordArray[i].length- xgramLength + 1
        if (xGramsInCurrent < 0) {
            xGramsInCurrent = 0
        }
        count += xGramsInCurrent
    }

    return count
}
