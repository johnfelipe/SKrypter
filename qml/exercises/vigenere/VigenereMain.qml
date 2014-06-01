import QtQuick 2.2

import "../../exercises"

CryptoMain {
    cryptosys: "Vigenere"
    exerciseModel: [
        {
            "picture": "/images/vigenere/vigenere_menu.png",
            //: Maximum character limit is 22
            "title": qsTr("1. Encryption"),
            "file": "vigenere/Vigenere_1.qml",
            "type": "Vigenere1Exercise"
        },

        {
            "picture": "/images/vigenere/vigenere_menu_2.png",
            //: Maximum character limit is 22
            "title": qsTr("2. Key?"),
            "file": "vigenere/Vigenere_2.qml",
            "type": "Vigenere2Exercise"
        },

        {
            "picture": "/images/vigenere/vigenere_menu_3.png",
            //: Maximum character limit is 22
            "title": qsTr("3. Kasiski"),
            "file": "vigenere/Vigenere_3.qml",
            "type": "Vigenere3Exercise"
        },

        {
            "picture": "/images/vigenere/vigenere_menu_4.png",
            //: Maximum character limit is 22
            "title": qsTr("4. FC"),
            "file": "vigenere/Vigenere_4.qml",
            "type": "Vigenere4Exercise",
        },

        {
            "picture": "/images/vigenere/vigenere_menu_5.png",
            //: Maximum character limit is 22
            "title": qsTr("5. Friedman Test"),
            "file": "vigenere/Vigenere_5.qml",
            "type": "Vigenere5Exercise"
        },

        {
            "picture": "/images/vigenere/vigenere_menu_6.png",
            //: Maximum character limit is 22
            "title": qsTr("6. Sinkov"),
            "file": "vigenere/Vigenere_6.qml",
            "type": "Vigenere6Exercise"
        },

        {
            "picture": "/images/vigenere/vigenere_menu_7.png",
            //: Maximum character limit is 22
            "title": qsTr("7. Attack"),
            "file": "vigenere/Vigenere_7.qml",
            "type": "Vigenere7Exercise"
        }
    ]
}
