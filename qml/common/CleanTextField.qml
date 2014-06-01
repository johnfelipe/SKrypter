import QtQuick 2.0

import "../exercises/alphabet.js" as Alphabet

SKrypterTextField {
    verticalAlignment: TextInput.AlignVCenter

    onTextChanged: {
        var pos = cursorPosition
        var leftText = getText(0, pos)
        var rightText = getText(pos, length)

        leftText = Alphabet.cleanText(leftText, false, "", exercise.language)
        rightText = Alphabet.cleanText(rightText, false, "", exercise.language)
        text = leftText + rightText
        cursorPosition = leftText.length
    }
}
