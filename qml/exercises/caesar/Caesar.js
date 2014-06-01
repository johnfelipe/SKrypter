.pragma library

.import "../alphabet.js" as Alphabet
.import "../../common/Globals.js" as Globals

/**
 * This function either encrypts or decrypts text.
 *
 * @param  text The text that has to be crypted
 * @param  key The key
 * @param  isEncrypt says whether to encrypt or decrypt
 * @return  the crypted text
 */
function crypt(text, key, isEncrypt) {
    if (!isEncrypt) {
        key = (Globals.alphabet_length - key) % Globals.alphabet_length;
    }

    //call function in alphabet.js
    var output = Alphabet.shiftLetters(text, key)
    return output
}

/*************************** CHECK FUNCTIONS ****************/

/**
 * This function checks whether a plain and cipher text could have been
 * encrypted with the given key.
 *
 * @param  plaintext The plaintext
 * @param  ciphertext The ciphertext
 * @param  key The key
 * @return bool indicating whether the plaintext can result in the ciphertext
 */
function check(plaintext, ciphertext, key) {
    return crypt(plaintext, key, true) === ciphertext
}

/**
 * This function checks whether a key is correct or not based on
 * a letter from the plain and ciphertext.
 *
 * @param  key The key
 * @param  plainletter A given letter from the plaintext
 * @param  cipherletter A given letter from the ciphertext
 * @return  bool indicating whether key is correct or not
 */
function checkKey(key, plainletter, cipherletter) {
    return key === getKeyFromLetters(plainletter, cipherletter)
}


/**
 * This function calculates frequencies of all letters in a text.
 *
 * @param  text The text that has to be analysed
 * @return  an array containing all frequencies (at pos 0 frequency of A)
 */
function calculateFrequencies(text) {
    var numberOfLetters = []

    for (var i=0; i<Globals.alphabet_length; i++) {
        numberOfLetters[i]=0;
    }

    if (text.length ===0){
        return numberOfLetters
    }

    var totalLetters = 0;

    for (var i=0; i < text.length; i++) {
        var current = text.charCodeAt(i);
        var index = Alphabet.charCodeToIndex(current);
        if (index !== -1) {
            numberOfLetters[index]++;
            totalLetters++
        }
    }

    for (var i=0; i<numberOfLetters.length; i++) {
        numberOfLetters[i] = numberOfLetters[i]/totalLetters
    }

    return numberOfLetters
}

/**
 * This function turns an array of frequencies into a model. This is useful
 * if for example wishing to sort the array and keeping information about
 * letters.
 *
 * @param  frequencies the frequencies of letters (at pos 0 frequency of A)
 * @return  an array containing the frequencies together with the letter
 */
function createModelFromFrequencies(frequencies) {
    var stats = []

    for (var i=0; i<frequencies.length; i++) {
        stats[i] = {"letter": Alphabet.indexToUpperString(i), "percentage": frequencies[i]}
    }

    return stats
}

/**
 * This function calculates the three most frequent letters
 * and compares them to the order of letters entered by the user.
 *
 * @param  text The text that has to be analysed
 * @param  userResult string of letters entered by the user ordered
 * @return  bool indicating whether the analysed text really has the indicated letters as most frequent
 */
function checkFrequency(text, userResult) {
    if (text.length ===0) {
        //by definition any kind of order will be correct
        return true
    }

    var frequencies = calculateFrequencies(text)
    var stats = createModelFromFrequencies(frequencies)
    //element of stats of form {"letter":"A", "percentage": "1.345"}

    //this function sorts the frequencies in descending order (it ignores alphabetical order)
    stats.sort(function(a, b) {
        return (b.percentage - a.percentage);
    });

    //create lists of letters with same frequency Array<String>
    var orderedLetters = ["", "", ""]
    var counter = 0
    orderedLetters[counter] += stats[0].letter

    //loop through the ordered stats list until we have found all letters with
    //the user result most occurring frequencies
    for (var i=0; i<25; i++) {
        if (stats[i].percentage !== stats[i+1].percentage) {
            //if percentage is the same we want to add to current list, else start a new one
            counter ++
        }
        if (counter > userResult.length - 1) {
            break;
        }

        orderedLetters[counter] += stats[i+1].letter
    }

    //check user result
    var stringToCheckIndex = 0
    for (var i=0; i<userResult.length; i++) {
        var currentLetter = userResult[i].toUpperCase()

        if (orderedLetters[stringToCheckIndex].indexOf(currentLetter) === -1) {
            return false
        }
        else {
            //remove the character from the string
            orderedLetters[stringToCheckIndex] = orderedLetters[stringToCheckIndex].replace(currentLetter, "")

            //if the string is empty we move to the next frequent group of letters
            if (orderedLetters[stringToCheckIndex].length <= 0) {
                stringToCheckIndex++
            }
        }
    }

    return true

}

/*************************** TEXT FUNCTIONS ****************/

/**
 * This function calculates the key based on a plaintext letter
 * and a cipher text letter
 *
 * @param  plainletter A given letter from the plaintext
 * @param  cipherletter A given letter from the ciphertext
 * @return  the key
 */
function getKeyFromLetters(plainletter, cipherletter) {
    var plainIndex = Alphabet.charCodeToIndex(plainletter.charCodeAt(0))
    var cipherIndex = Alphabet.charCodeToIndex(cipherletter.charCodeAt(0))
    var key = (Globals.alphabet_length - (plainIndex - cipherIndex)) % Globals.alphabet_length
    return key
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
function markText(plaintext, ciphertext, key, isEncrypt) {
    var solution
    var textToCheck
    if (isEncrypt) {
        solution = crypt(plaintext, key, true)
        textToCheck = ciphertext
    }
    else {
        solution = crypt(ciphertext, key, false)
        textToCheck = plaintext
    }

    return Alphabet.markText(textToCheck, solution)
}

/**
 * This function sorts the letters in the model based on the
 * base_model and the key. It will basically show the mapping
 * of letter in the base_model to letters in the model. The
 * base_model can be ordered any way. Will update the stats
 * of the model.
 *
 * @param  model the model to change the plaintext
 * @param  base_mode the base model the ciphertext
 * @param  key the key used
 * @param  text the text used for the stats
 * @param  isRelative used for the stats
 */
function matchModel(model, base_model, key, text, isRelative) {
    if (model.count !== base_model.count) {
        console.warn("Caesar.js, matchModel: model lengths do not match")
        return
    }

    for (var i=0; i<base_model.count; i++) {
        var curLetterIndex = Alphabet.charCodeToIndex(base_model.get(i).letter.charCodeAt(0))
        var matchingLetterIndex = (curLetterIndex + key) % Globals.alphabet_length
        model.get(i).letter = Alphabet.indexToUpperString(matchingLetterIndex)
    }

    Alphabet.updateStats(text, model, isRelative)
}
