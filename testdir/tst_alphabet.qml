import QtQuick 2.2
import QtTest 1.0

import "../qml/exercises/alphabet.js" as Alphabet

TestCase {
    name: "Alphabet Tests"

    function test_charCodeToIndex_data() {
        return [
                {charCode: "A".charCodeAt(0), answer: 0},
                {charCode: "Z".charCodeAt(0), answer: 25},
                {charCode: "a".charCodeAt(0), answer: 0},
                {charCode: "z".charCodeAt(0), answer: 25},
                ]
    }

    function test_charCodeToIndex(data) {
        var result = Alphabet.charCodeToIndex(data.charCode)
        compare(result, data.answer)
    }

    function test_indexToUpperString_data() {
        return [
                {index: 0, answer: "A"},
                {index: 25, answer: "Z"},
                ]
    }

    function test_indexToUpperString(data) {
        var result = Alphabet.indexToUpperString(data.index)
        compare(result, data.answer)
    }

    function test_indexToLowerString_data() {
        return [
                {index: 0, answer: "a"},
                {index: 25, answer: "z"},
                ]
    }

    function test_indexToLowerString(data) {
        var result = Alphabet.indexToLowerString(data.index)
        compare(result, data.answer)
    }

    function test_isUpperCase_data() {
        return [
                {charCode: "A".charCodeAt(0), answer: true},
                {charCode: "Z".charCodeAt(0), answer: true},
                {charCode: "a".charCodeAt(0), answer: false},
                {charCode: "z".charCodeAt(0), answer: false},
                ]
    }

    function test_isUpperCase(data) {
        var result = Alphabet.isUpperCase(data.charCode)
        compare(result, data.answer)
    }

    function test_stringKeyToIndexKey_data() {
        return [
                {key: "ABC", isEncrypt: true, answer: [0, 1, 2]},
                {key: "A%C", isEncrypt: true, answer: [0, -1, 2]},
                {key: "ABC", isEncrypt: false, answer: [0, 25, 24]},
                ]
    }

    function test_stringKeyToIndexKey(data) {
        var result = Alphabet.stringKeyToIndexKey(data.key, data.isEncrypt)
        compare(result, data.answer)
    }

    function test_invertMapping_data() {
        return [
                {key: [0, 1, 2], answer: [0, 1, 2]},
                {key: [2, 1, 0], answer: [2, 1, 0]},
                ]
    }

    function test_invertMapping(data) {
        var result = Alphabet.invertMapping(data.key)
        compare(result, data.answer)
    }



    //********************** Shift Letters *******************************************

    function test_shiftLetters_data() {
        return [
                    {text: "Mt. Annapurna", key: 0, answer: "Mt. Annapurna" },
                    {text: "Mt. Annapurna", key: 1, answer: "Nu. Boobqvsob" },
                    {text: "Mt. Annapurna", key: 25, answer: "Ls. Zmmzotqmz" },
                ]
    }

    function test_shiftLetters(data) {
        var result = Alphabet.shiftLetters(data.text, data.key)
        compare(result, data.answer)
    }

    function test_updateAtIndex_data() {
        return [
                {text: "aaaa", index: 0, character: "b", answer: "baaa"},
                {text: "aaaa", index: 3, character: "b", answer: "aaab"},
                {text: "", index: 1, character: "b", answer: ""},
                ]
    }

    function test_updateAtIndex(data) {
        var result = Alphabet.updateAtIndex(data.text, data.index, data.character)
        compare(result, data.answer)
    }

    //function cleanText to be tested later when language support added


    //no test for correctText function

    //no test for createAlphabet

    ListModel {
        id: alphabetically_ordered_model
        Component.onCompleted: {
            Alphabet.createOrUpdateAlphabet(alphabetically_ordered_model, false)
        }
    }

    ListModel {
        id: percentage_ordered_model
        Component.onCompleted: {
            Alphabet.createOrUpdateAlphabet(percentage_ordered_model, false)
            Alphabet.sortModel(percentage_ordered_model, false)
        }
    }

    ListModel {
        id: changeable_model
        Component.onCompleted: {
            Alphabet.createOrUpdateAlphabet(changeable_model, false)
        }
    }


    //Test kind of superfluous cause we use the function to test in the initialization of percentage_ordered_model...
    function test_sortModel_data() {
        return [
                {model: changeable_model, sortByLetters: true, answer: alphabetically_ordered_model},
                {model: changeable_model, sortByLetters: false, answer: percentage_ordered_model},
                {model: changeable_model, sortByLetters: true, answer: alphabetically_ordered_model},
                {model: changeable_model, sortByLetters: false, answer: percentage_ordered_model},
                ]
    }

    function test_sortModel(data) {
        Alphabet.sortModel(data.model, data.sortByLetters)
        for (var i=0; i<data.model.count; i++) {
            compare(data.model.get(i).letter, data.answer.get(i).letter)
        }


    }

    //not testing sortModelRandomly
    //not testing percentageToHeight


 //********************** update Stats *******************************************

    ListModel {
        id: test_model_updateStats
        Component.onCompleted: {
            Alphabet.createOrUpdateAlphabet(test_model_updateStats, true)
        }
    }

    function test_updateStats_data() {
        return [
                    {text: "ABCDE", model: test_model_updateStats, isRelative: false, answer: 1},
                    {text: "ABCDE", model: test_model_updateStats, isRelative: true, answer: 20},
                    {text: "ABABAE", model: test_model_updateStats, isRelative: false, answer: 3},
                    {text: "ABABAE", model: test_model_updateStats, isRelative: true, answer: 50},
                ]
    }

    function test_updateStats(data) {
        Alphabet.updateStats(data.text, data.model, data.isRelative)
        compare(data.model.get(0).percentage, data.answer, "result updateStats")
    }

    ListModel {
        id: test_model_createXGramModel
    }

    function test_createXGramModel_data() {
        return [
                {list: [], count: 0},
                {list:["aaa", 0.1], count:1},
                {list:["aaa", 0.1, "bcd", 0.2], count:2},
                ]
    }

    function test_createXGramModel(data) {
        Alphabet.createXGramModel(test_model_createXGramModel, data.list)
        compare(test_model_createXGramModel.count, data.count)
        for (var i=0; i<test_model_createXGramModel.count; i++) {
            test_model_createXGramModel.get(i).xgram = data.list[2*i-1]
            test_model_createXGramModel.get(i).percentage = data.list[2*i]

        }
    }

    //not testing initLanguageXGram as is will change anyway

    //not testing markXGrams

    ListModel {
        id: shift_model
        Component.onCompleted: {
            Alphabet.createOrUpdateAlphabet(shift_model, true)
        }
    }

    function test_shiftModel_data() {
        return [
                {pos: -25, answer: "Z"},
                {pos: 0, answer: "A"},
                {pos: 1, answer: "Z"},
                {pos: -1, answer: "B"},
                {pos: 25, answer: "B"},

                ]
    }

    //tests shiftModel and shiftModelToLetter
    function test_shiftModel(data) {
        Alphabet.shiftModelToLetter(shift_model, 0)
        Alphabet.shiftModel(shift_model, data.pos)
        compare(shift_model.get(0).letter, data.answer)
    }

}
