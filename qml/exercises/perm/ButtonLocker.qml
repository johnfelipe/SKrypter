import QtQuick 2.0
import QtQuick.Layouts 1.0

import "../../common"
import "Perm.js" as Perm
import "../alphabet.js" as Alphabet
import "../../common/Globals.js" as Globals

/**
  * This class is responsible for displaying an interactive
  * key for Perm. The top row of the key represents the cipher
  * alphabet. The bottom row of the key represents the language
  * statistics for letters of the chosen language. In the middle
  * we have an interactive row of buttons that lock letters in place.
  * If letter pairs get locked in place the system automatically
  * decrypts this letter pair.
  * The class is highly customizable, descriptions of individual
  * parameters are next to their definition.
  *
  */
Item {
    id: root

    //indicates whether we display the statistics or not
    property bool onlyPureLetters: false
    property bool showFlag: true
    property bool isLockable: true //indicates whethe lockButtons should be displayed or not

    property string language //indicates the language used for the language flag

    property string text //text that is needed to compute statistics
    property var map //The map to be used for decryption
    //If an A in the ciphertext is a C in the plaintext then map[0] = 2 if it is locked!

    property bool calculateFullMap: false //indicates if the fullMap should be computed
    property var fullMapDecryption //fullMap stores the map for decryption ignoring locked positions
    property var fullMapEncryption //fullMap stores the map for encryption ignoring locked positions
    //to use it set calculateFullMap to in the ButtonLocker Component!

    property string lowerLettersColor: "black" //indicates the color the borders of the lower row have

    property alias text_frequency_model: text_frequency_model //the model containing details about the text
    property alias language_frequency_model: language_frequency_model //the model containing details about the language statistics
    property alias button_repeater: button_repeater //the repeater which contains all the lock buttons

    property bool hasLockedLetters: false //indicates whether any letters are currently locked

    property string markedUpperText: ""
    property string markedLowerText: ""

    //can be called from outside to indicate that model has changed and therefore letters need to be remarked
    function remarkLetters() {
        dyn_statistik.remarkLetters()
        statistik.remarkLetters()
    }

    Timer {
        id: timer
        interval: 500;
        triggeredOnStart: true

        onTriggered: {
            triggeredOnStart = false
            Alphabet.updateStats(text, text_frequency_model, true)
        }
    }

    onTextChanged: {
        timer.restart()
    }

    //function updates all maps. Can also be called from outside if for example the models get sorted
    function updateMaps() {
        map = Perm.getMapping(text_frequency_model, language_frequency_model, button_repeater)
        if (root.calculateFullMap) {
            root.fullMapDecryption = Perm.getFullMapping(text_frequency_model, language_frequency_model)
            root.fullMapEncryption = Alphabet.invertMapping(fullMapDecryption)
        }
    }

    function setLockedLetters(lockedLetters) {
        Perm.setLockedLetters(button_repeater, language_frequency_model, lockedLetters);
        root.hasLockedLetters = Perm.hasLockedLetters(button_repeater)
    }

    ListModel {
        id: text_frequency_model
    }

    ListModel {
        id: language_frequency_model
    }


    Column {
        id: algorithm_column
        anchors.margins: 5
        anchors.fill: parent
        spacing: 5

        FrequencyLetters {
            id: dyn_statistik
            onlyPureLetters: root.onlyPureLetters
            usedModel: text_frequency_model
            switchable: true
            borderColor: Globals.pink3
            languageFlag: root.showFlag ? "cipher" : ""
            outerHeight: (algorithm_column.height- 2*algorithm_column.spacing)*45/100
            markedLetter: root.markedUpperText
            releaseFunction: root.updateMaps
        }

        RowLayout {
            id: row_layout
            height: (algorithm_column.height- 2*algorithm_column.spacing)*10/100
            width: parent.width

            Rectangle {
                width: dyn_statistik.flagWidth
                visible: root.showFlag
            }

            Row {
                id: button_reihe
                visible: root.isLockable
                anchors.margins: 5
                Layout.fillHeight: root.isLockable
                Layout.fillWidth: root.isLockable
                spacing: 5

                Repeater {
                    id: button_repeater
                    model: Globals.alphabet_length

                    function unlockAll() {
                        for (var i=0; i<model; i++) {
                            button_repeater.itemAt(i).locked = false;
                        }
                        //update the map
                        map = Perm.getMapping(text_frequency_model, language_frequency_model, button_repeater)
                        root.hasLockedLetters = false
                    }

                    Item {
                        id: button_rectangle
                        width: (button_reihe.width - button_reihe.spacing*(Globals.alphabet_length-1))/Globals.alphabet_length
                        height: parent.height
                        property bool locked: false

                        Image {
                            source: button_rectangle.locked ? (mouse_area.pressed ? "/icons/button_green_clicked.svg" : "/icons/button_green.svg") : (mouse_area.pressed ? "/icons/button_orange_clicked.svg" : "/icons/button_orange.svg")
                            anchors.fill: parent
                        }

                        MouseArea {
                            id: mouse_area
                            anchors.fill: parent
                            onClicked: {
                                button_rectangle.locked = !button_rectangle.locked
                                map = Perm.getMapping(text_frequency_model, language_frequency_model, button_repeater)
                                root.hasLockedLetters = Perm.hasLockedLetters(button_repeater)
                            }
                        }
                    }
                }
            }
        }

        FrequencyLetters {
            id: statistik
            onlyPureLetters: root.onlyPureLetters
            usedModel: language_frequency_model
            borderColor: root.lowerLettersColor
            languageFlag: root.showFlag ? root.language : ""
            outerHeight: (algorithm_column.height- 2*algorithm_column.spacing)*45/100
            markedLetter: root.markedLowerText
        }
    }

    onLanguageChanged: {
        //initialize single letter frequencies
        if (language_frequency_model.count === 0) {
            Alphabet.createOrUpdateAlphabet(language_frequency_model, false, language)
        }

        if (text_frequency_model.count === 0) {
            Alphabet.createOrUpdateAlphabet(text_frequency_model, true, language)
        }

        Alphabet.updateStats(root.text, text_frequency_model, true)

        if (root.calculateFullMap) {
            root.fullMapDecryption = Perm.getFullMapping(text_frequency_model, language_frequency_model)
            root.fullMapEncryption = Alphabet.invertMapping(fullMapDecryption)
        }
    }
}
