import QtQuick 2.2

import "../../exercises"

CryptoMain {
    cryptosys: "Caesar"
    exerciseModel: [
        {
            "picture": "/images/caesar/caesar_menu.png",
            //: Maximum character limit is 22
            "title": qsTr("1. Encryption"),
            "type": "Caesar1Exercise",
            "file": "/qml/exercises/caesar/Caesar_1.qml"
        },

        {
            "picture": "/images/caesar/caesar_menu_2.png",
            //: Maximum character limit is 22
            "title": qsTr("2. Decryption"),
            "type": "Caesar2Exercise",
            "file": "caesar/Caesar_2.qml"
        },

        {
            "picture": "/images/caesar/caesar_menu_3.png",
            //: Maximum character limit is 22
            "title": qsTr("3. Brute-Force"),
            "type": "Caesar3Exercise",
            "file": "caesar/Caesar_3.qml"
        },

        {
            "picture": "/images/caesar/caesar_menu_4.png",
            //: Maximum character limit is 22
            "title": qsTr("4. Frequencies"),
            "file": "caesar/Caesar_4.qml",
            "type": "Caesar4Exercise"
        },

        {
            "picture": "/images/caesar/caesar_menu_5.png",
            //: Maximum character limit is 22
            "title": qsTr("5. Attack"),
            "file": "caesar/Caesar_5.qml",
            "type": "Caesar5Exercise"
        }
    ]
}
