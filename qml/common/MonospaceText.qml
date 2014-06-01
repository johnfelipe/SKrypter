import QtQuick 2.0

Item {
    id: root
    property string text
    width: skrypter_text.width
    height: skrypter_text.height

    SKrypterText {
        id: skrypter_text
        text: "<pre>" + root.text + "</pre>"
        textFormat: TextEdit.RichText
        font.pixelSize: 18
    }

}
