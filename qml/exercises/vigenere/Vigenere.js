.pragma library

.import "../alphabet.js" as Alphabet

/**
 * This function either encrypts or decrypts text using the key
 *
 * @param  text The text that has to be crypted
 * @param  key the ENCRYPTION key! no matter if isEncrypt is true or false
 * @param  isEncrypt whether to encrypt or decrypt
 * @return  the crypted text
 */
function crypt(text, key, isEncrypt) {
    if (key === "") {
        return text
    }

    //translation of the string key to an array of key indexes
    var keys = Alphabet.stringKeyToIndexKey(key, isEncrypt)

    //crypting
    var result = ""
    var counter = 0
    for (var i = 0; i<text.length; i++) {
        var index = Alphabet.charCodeToIndex(text.charCodeAt(i))
        if (index === -1) {
            result += text[i]
        }
        else {
            if (keys[counter%key.length] === -1) {
                result += "_"
            }
            else {
                result += Alphabet.shiftLetters(text[i], keys[counter%key.length])
            }
            counter++;
        }
    }

    return result
}

/*************************** CHECK FUNCTIONS ****************/

/**
 * This function checks whether a plain and cipher text could have been
 * en or decrypted with the given key.
 *
 * @param  plaintext The plaintext
 * @param  ciphertext The ciphertext
 * @param  key The key
 * @param  isEncrypt says whether to encrypt or decrypt
 * @return bool indicating whether the plaintext can result in the ciphertext
 */
function check(plaintext, ciphertext, key, isEncrypt) {
    if (isEncrypt) {
        return crypt(plaintext, key, isEncrypt) === ciphertext
    }
    else {
        return crypt(ciphertext, key, isEncrypt) === plaintext
    }
}


/*************************** TEXT FUNCTIONS ****************/


/**
 * This function creates a text which repeats the given key in all places it is needed
 * for crypting a text manually.
 *
 * @param  key The key to be repeated
 * @param  the text to which the key has to be matched
 * @return the adapted key text
 */
function createKeyText(key, text) {
    var keyText = ""

    var j = 0; //indicates key position
    for (var i=0; i< text.length; i++) {
        var letterIndex = Alphabet.charCodeToIndex(text.charCodeAt(i))

        if (letterIndex >=0) {
            keyText += key[j]
            j = (j+1) % key.length;
        }

        else {
            keyText += text[i]
        }
    }

    return keyText
}

/**
 * This function splits the text based on the Vigenère key length into parts that
 * where crypted using the same position of the key.
 *
 * @param  the text to which the key has to be matched
 * @param  keyLength The key length
 * @return the split text
 */
function splitText(text, keyLength) {
    var subTexts = []
    for (var j = 0; j<keyLength; j++) {
        subTexts[j] = ""
    }

    var counter = 0

    for (var i = 0; i<text.length; i++) {
        var index = Alphabet.charCodeToIndex(text.charCodeAt(i))
        if (index !== -1) {
            subTexts[counter%keyLength] += text[i];
            counter++;
        }
    }

    return subTexts
}

/**
 * This function returns the position without counting the blanks
 * based on the text passed and the marked position
 *
 * @param  text the text in which we have to calculate the position
 * @param  position the positiont that was marked
 * @return the position ignoring the spaces
 */
function getPositionWithoutBlanks(text, position) {
    var counter = 0

    for (var i = 0; i<position; i++) {
        var index = Alphabet.charCodeToIndex(text.charCodeAt(i))
        if (index !== -1) {
            counter++;
        }
    }

    return counter + 1
}

/*************************** KASISKI FUNCTIONS ****************/


/**
 * This function returns all positions of searchString occurrences
 * in the passed text
 *
 * @param  text the text in which we have to calculate the positions
 * @param  searchString the string of whichw e want to know all positions
 * @return array with all starting positions
 */
function getPositions(text, searchString) {
    if (text.indexOf(" ") !== -1) {
        text = text.replace(/ /g, "");
    }

    var regex = new RegExp(searchString,'gi');

    var result = []
    var finding
    while ((finding = regex.exec(text))){
      result.push(finding.index + 1);
    }

    return result
}

/**
 * This function returns all differences between the given positions
 *
 * @param  positions the positions of which we need the differences
 * @return all differences
 */
function getDifferences(positions) {
    var result = []

    for (var i=0; i < positions.length; i++) {
        for (var j=i+1; j < positions.length; j++) {
            result.push(positions[j] - positions[i])
        }
    }

    return result
}

/**
 * This function calculats the ggt of the given numbers
 *
 * @param  a the first value
 * @param  b the second value
 * @return ggT(a,b)
 */
function getGGT(a, b) {
    if (b === 0) {
        return a;
    }
    else {
        return getGGT(b, a%b);
    }
}

/**
 * This function calculats the ggt of a list of numbers
 *
 * @param  number the number we want the ggt of
 * @return ggT of all number
 */
function getGGTFromList(numbers) {
    var currentGGT = numbers[0]
    for (var i=1; i<numbers.length; i++) {
        currentGGT = getGGT(currentGGT, numbers[i])
    }

    return currentGGT
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
 * This function marks the passed test at every keyLength-d position starting
 * at an offset of offset (used to indicate current partial text for vigenere)
 *
 * @param  text The text to be marked
 * @param  keyLength the length of the key
 * @param  offset indicates where to start marking
 * @return  the marked text
 */
function markCurrentText(text, keyLength, offset) {
    var resultText = ""

    var counter = 0
    for (var i = 0; i<text.length; i++) {
        var index = Alphabet.charCodeToIndex(text.charCodeAt(i))

        if (index === -1 && text[i] !== "_") {
            resultText += text[i]
        }
        else {
            if ((counter - offset)%keyLength === 0) {
                resultText += "<font color='#1ca938' style='font-size:20px'><i><b>" + text[i] + "</i></b></font>"
            }
            else {
                resultText += text[i]
            }

            counter++
        }
    }

    return resultText
}
