import QtQuick 2.2

import "../../common"
import "Perm.js" as Perm
import "../alphabet.js" as Alphabet
import "../../common/Globals.js" as Globals

import CCode 1.0


Column {
    id: root
    spacing: 5

    property int xgramLength
    property int numberOfXgrams
    property string text //ciphertext
    property string plainText: ""
    property bool isPercent: true
    property bool teacherMode: false
    property var mapping

    property string language: "de"

    property alias selectedXgram: xgram_model_frequencies.selectedXgram

    Timer {
        id: timer
        interval: 500;
        triggeredOnStart: true

        onTriggered: {
            triggeredOnStart = false

            if (teacherMode) {
                updateTeacherModel()
            }
            else {
                var xgram_list = Calculations.calculateRelativeXGrams(root.text, root.xgramLength, root.numberOfXgrams)
                Alphabet.createXGramModel(xgram_model, xgram_list)
            }
        }
    }

    function updateTeacherModel() {
        if (!mapping) {
            return
        }

        var text_xgrams = Calculations.calculateRelativeXGrams(root.plainText, root.xgramLength, root.numberOfXgrams)

        var existing_xgrams = {}
        var xgram_list = []
        for (var i=0; i<xgram_language_frequency_model.count; i++) {
            var xgram = xgram_language_frequency_model.get(i).xgram.toUpperCase()
            if (existing_xgrams[xgram]) {
                continue
            }

            existing_xgrams[xgram] = true
            xgram_list.push({"xgram": xgram, "percentage": Stats.getFrequency(xgram, language)});
        }

        for (var i=0; i<text_xgrams.length; i = i + 2) {
            var xgram = text_xgrams[i].toUpperCase()
            if (existing_xgrams[xgram]) {
                continue
            }

            existing_xgrams[xgram] = true
            xgram_list.push({"xgram": xgram, "percentage": Stats.getFrequency(xgram, language)})
        }

        xgram_list.sort(function(a,b){return b.percentage - a.percentage})

        extended_xgram_language_frequency_model.clear()
        for (var i=0; i<xgram_list.length; i++) {
            extended_xgram_language_frequency_model.append(xgram_list[i])
        }

        var numberOfXGrams = Perm.findNumberOfXgrams(plainText, xgramLength)
        xgram_model.clear()
        for (var i=0; i<xgram_list.length; i++) {
            var xgram = xgram_list[i].xgram

            var regex = new RegExp(xgram,'gi');

            //find the xgram in the plaintext
            var foundXGrams = plainText.match(regex);

            //setting the count
            var count = foundXGrams ? foundXGrams.length : 0

            //appending to the model
            if (numberOfXGrams <= 0) {
                xgram_model.append({"xgram":Perm.crypt(xgram, mapping), "percentage": 0})
            }
            else {

                xgram_model.append({"xgram":Perm.crypt(xgram, mapping), "percentage": count*100/numberOfXGrams})
            }

        }
    }

    onTextChanged: {
        timer.restart()
    }

    function updateAfterLanguageChange() {
        if (root.language !== "") {
            Alphabet.getLanguageXGram(xgram_language_frequency_model, root.xgramLength, root.numberOfXgrams, root.language)
            if (teacherMode) {
                updateTeacherModel()
            }
        }
    }

    onLanguageChanged: {
        updateAfterLanguageChange()
    }

    ListModel {
        id: xgram_model
    }

    ListModel {
        id: xgram_language_frequency_model
    }

    ListModel {
        id: extended_xgram_language_frequency_model
    }

    XGramFrequencies {
        id: xgram_model_frequencies
        usedModel: xgram_model
        borderColor: Globals.pink3
        widthFactor: teacherMode ? xgram_model.count :Math.max(xgram_model.count, xgram_language_frequency_model.count)
        clickable: true
        outerHeight: (root.height - root.spacing)*50/100
        isPercent: root.isPercent
    }

    XGramFrequencies {
        id: lower_xgrams
        usedModel: teacherMode ? extended_xgram_language_frequency_model : xgram_language_frequency_model
        languageFlag: root.language
        widthFactor: teacherMode ? extended_xgram_language_frequency_model.count : Math.max(xgram_model.count, xgram_language_frequency_model.count)
        outerHeight: (root.height - root.spacing)*50/100
        isPercent: root.isPercent
    }

    Component.onCompleted: {
        //initialize xgrams
        updateAfterLanguageChange()
    }
}
