import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import "alphabet.js" as Alphabet

import "../common/Globals.js" as Globals


TextArea {
    anchors.margins: 5
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom

    font.pixelSize: 18
    wrapMode: TextEdit.Wrap
    textFormat: TextEdit.RichText

    readOnly: true

    style: TextAreaStyle {
        backgroundColor: readOnly ? Globals.gray1 : "white"
    }

    // public
    property bool isCase: true
    property bool isBlanks: true
    property bool ignoreUnderscores: false
    property string language

    // private
    property bool hasPartialSolution: initialText != ""
    property string initialText

    // contains the text without any markup
    property string currentText: ""

    function removeHtml(text) {
        var paragraph = text.match(/<p.*>.*<\/p>/g)

        if (paragraph) {
            text = paragraph[0]
            for (var i=1; i<paragraph.length; i++) {
                text += "\n" + paragraph[i]
            }
        }
        return text.replace(/<[^>]+>/g, "")
    }

    function getSimpleText() {
        return removeHtml(text)
    }

    function setInitialTextForPartial(text) {
        //Need to ignore "_" because we may have a partial text
        var ignoredCharacters = "_"
        if (isBlanks) {
            ignoredCharacters += " "
        }

        initialText = Alphabet.cleanText(text, isCase, ignoredCharacters, language)

        // Set initial solution to all "_" (nothing locked)
        setText(initialText.replace(/./g, "_"))
    }

    // This function is used to set the text from within a program
    function setText(newText) {
        var pos = cursorPosition

        if (hasPartialSolution) {
            newText = Alphabet.correctText(newText, initialText)
        }

        currentText = removeHtml(newText)
        text = newText
        cursorPosition = pos
    }

    onTextChanged: {
        // Make sure the entered text is not too long, otherwise program might get really slow / crash
        // This should be enough for our purposes
        if (length > 10000) {
            remove(10000, length)
        }

        //to prevent infinite loop when text is not changed by user(function is also called when text is only marked)
        //if we want to force a change of the text via program we use setText function
        if (readOnly) {
            return
        }

        //program changes text (e.g. to give feedback), unless the user actually changes the text, we do not want to change anything
        //to test we need to remove the html markup (e.g. bold settings)
        if (removeHtml(text) === currentText) {
            return
        }

        //we are in the case where the user has changed the text

        //mark cursor position and treat text to left and right side so that cursor position does not move for user
        var pos = cursorPosition
        var leftText = getText(0, pos)
        var rightText = getText(pos, length)

        var ignoredCharacters = ""

        if (hasPartialSolution || ignoreUnderscores) {
            ignoredCharacters += "_"
        }
        if (isBlanks) {
            ignoredCharacters += " "
        }

        leftText = Alphabet.cleanText(leftText, isCase, ignoredCharacters, language)
        rightText = Alphabet.cleanText(rightText, isCase, ignoredCharacters, language)

        // This is needed when using rich text to avoid stack overflows
        currentText = leftText + rightText

        text = currentText

        cursorPosition = leftText.length
    }

    Component.onCompleted: {
        if (initialText == "") {
            var ignoredCharacters = ""
            if (isBlanks) {
                ignoredCharacters += " "
            }
            if (ignoreUnderscores) {
                ignoredCharacters += "_"
            }
            text = Alphabet.cleanText(getSimpleText(), isCase, ignoredCharacters, language)
        }
    }
}
