import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

/*This is a helper for creating SKrypterTextFields that only accept
  numbers between a certain range. It is not possible to enter
  an invalid number that is too high or too low, it is also not
  possible to enter anything but numbers.
  */
SKrypterTextField {
    property int minimum
    property int maximum
    property int number: (text !== "") ? parseInt(text) : 0

    onTextChanged: {
        var cleanedText = ""
        for (var i=0; i<text.length; i++) {
            var charCode = text[i].charCodeAt(0)
            //keeps all numbers, removes everything else
            if (charCode >= 48 && charCode <= 57) {
                cleanedText += String.fromCharCode(charCode);
            }
        }

        var currentKey = parseInt(cleanedText)
        if (currentKey < minimum) {
            cleanedText = minimum.toString()
        }

        if (currentKey > maximum) {
            cleanedText = maximum.toString()
        }

        text = cleanedText
    }
}
