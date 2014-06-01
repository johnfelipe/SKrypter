import QtQuick 2.2

import "../../exercises"

CryptoMain {
    cryptosys: "Perm"
    exerciseModel: [
        {
            "picture": "/images/perm/perm_menu.png",
            //: Maximum character limit is 22
            "title": qsTr("1. Encryption"),
            "file": "perm/Perm_1.qml",
            "type": "Perm1Exercise"
        },

        {
            "picture": "/images/perm/perm_menu_2.png",
            //: Maximum character limit is 22
            "title": qsTr("2. Key?"),
            "file": "perm/Perm_2.qml",
            "type": "Perm2Exercise"
        },

        {
            "picture": "/images/perm/perm_menu_3.png",
            //: Maximum character limit is 22
            "title": qsTr("3. Single Frequencies"),
            "file": "perm/Perm_3.qml",
            "type": "Perm3Exercise"

        },

        {
            "picture": "/images/perm/perm_menu_4.png",
            //: Maximum character limit is 22
            "title": qsTr("4. X-Grams"),
            "file": "perm/Perm_4.qml",
            "type": "Perm4Exercise"
        },

        {
            "picture": "/images/perm/perm_menu_5.png",
            //: Maximum character limit is 22
            "title": qsTr("5. Partial Attack"),
            "file": "perm/Perm_5.qml",
            "type": "Perm5Exercise"
        },

        {
            "picture": "/images/perm/perm_menu_6.png",
            //: Maximum character limit is 22
            "title": qsTr("6. Attack"),
            "file": "perm/Perm_5.qml",
            "type": "Perm6Exercise"
        }
    ]
}
