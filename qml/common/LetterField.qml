import QtQuick 2.2
import QtQuick.Controls 1.1

/*This is a helper for creating SKrypterTextFields that only accept
  a single capital case letter.
  */
SKrypterTextField {
    property string letter: text
    maximumLength: 1
    width: 40
    horizontalAlignment: TextInput.AlignHCenter
    verticalAlignment: TextInput.AlignVCenter

    onTextChanged: {
        if (text.length>0) {
            text = text.toUpperCase()
            var cleanedText = ""
            var charCode = text.charCodeAt(0)
            //keeps all letters, removes everything else
            if (charCode >= 65 && charCode <= 90) {
                cleanedText += String.fromCharCode(charCode);
            }

            text = cleanedText
        }
    }
}
