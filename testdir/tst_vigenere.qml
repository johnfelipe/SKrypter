import QtQuick 2.1
import QtTest 1.0

import "../qml/exercises/vigenere/Vigenere.js" as Vigenere
import "../qml/exercises/alphabet.js" as Alphabet

TestCase {
    name: "Vigenère Tests"

    function test_cryptVigenere_data() {
        return [
                    {text: "Annapurna", key: "ABC", isEncrypt: true, answer: "Aopaqwroc"},
                    {text: "Annapurna", key: "AZY", isEncrypt: false, answer: "Aopaqwroc"},
                    {text: "Anna purna", key: "AZY", isEncrypt: false, answer: "Aopa qwroc"},
                    {text: "Anna purna", key: "A_Y", isEncrypt: false, answer: "A_pa _wr_c"},
                    {text: "", key: "A", isEncrypt: false, answer: ""},
                    {text: "Annapurna", key: "", isEncrypt: true, answer: "Annapurna"},

                ]
    }

    function test_cryptVigenere(data) {
        var result = Vigenere.crypt(data.text, data.key, data.isEncrypt)
        compare(result, data.answer, "result crypt Vigenere")
    }

    function test_check_data() {
        return [
                {plaintext: "ABCD", ciphertext: "ABCD", key: "A", isEncrypt: true, answer: true},
                {plaintext: "ABCD", ciphertext: "ABCD", key: "A", isEncrypt: false, answer: true},
                ]
    }

    function test_check(data) {
        var result = Vigenere.check(data.plaintext, data.ciphertext, data.key, data.isEncrypt)
        compare(result, data.answer)
    }

    function test_createKeyText_data() {
        return [
                {key: "A", text: "AAA", answer: "AAA"},
                {key: "AB", text: "AAA", answer: "ABA"},
                {key: "HELLO", text: "AAA", answer: "HEL"},
                {key: "KEY", text: "AAA AAA", answer: "KEY KEY"},
                ]
    }

    function test_createKeyText(data) {
        var result = Vigenere.createKeyText(data.key, data.text)
        compare(result, data.answer)
    }

    function test_splitText_data() {
        return [
                {text: "AAAAA", keyLength: 2, isCase: false, answer: ["AAA", "AA"]},
                {text: "AAAAA", keyLength: 1, isCase: false, answer: ["AAAAA"]},
                {text: "AAAAA", keyLength: 5, isCase: false, answer: ["A", "A","A","A","A"]},
                {text: "AAA AA8", keyLength: 2, isCase: false, answer: ["AAA", "AA"]},
                {text: "AAA AA8", keyLength: 1, isCase: false, answer: ["AAAAA"]},
                {text: "AAA AA8", keyLength: 5, isCase: false, answer: ["A", "A","A","A","A"]},
                {text: "Hallo", keyLength: 2, isCase: true, answer: ["Hlo", "al"]},

                ]
    }

    function test_splitText(data) {
        var result = Vigenere.splitText(data.text, data.keyLength, data.isCase)
        compare(result, data.answer)
    }

    function test_getPositionWithoutBlanks_data() {
        return [
                {text: "test", position: 1, answer: 2},
                {text: "test two", position: 5, answer: 5},
                ]
    }

    function test_getPositionWithoutBlanks(data) {
        var result = Vigenere.getPositionWithoutBlanks(data.text, data.position)
        compare(result, data.answer)
    }

    function test_getPositions_data() {
        return [
                    {text: "IAIOSDJFKAMVYXIOCUVOAKWEMSADKX", xgram: "IO", answer: [3, 15]},
                    {text: "IAIOSDJFKAMVYXIOCUVOAKWEMSADKX", xgram: "IAI", answer: [1]},
                    {text: "IAIOSDJFKAMVYXIOCUVOAKWEMSADKX", xgram: "OEOEOEO", answer: []},
                    {text: "IAIOSDJFKA MVYXIOCUVOAKWEM SADKX", xgram: "IO", answer: [3, 15]},
                    {text: "IAIOS DJFKAMVYXIOCUVOAKWE MSADKX", xgram: "IAI", answer: [1]},
                    {text: "IAIOSD JFKAMVYXIOCUVOAKWEMS ADKX", xgram: "OEOEOEO", answer: []},
                ]
    }

    function test_getPositions(data) {
        var result = Vigenere.getPositions(data.text, data.xgram)
        compare(result, data.answer, "result getPositions Vigenere")
    }

    function test_getDifferences_data() {
        return [
                    {positions: [1, 5, 7], answer: [4, 2, 6]},
                    {positions: [1, 11], answer: [10]},
                    {positions: [33,34], answer: [1]},
                    {positions: [1], answer: []},
                    {positions: [], answer: []},
                ]
    }

    function test_getDifferences(data) {
        var result = Vigenere.getDifferences(data.positions)
        compare(result.sort(), data.answer.sort(), "result getDifferences Vigenere")
    }

    function test_getGGT_data() {
        return [
                    {a: 3, b: 10, answer: 1},
                    {a: 3, b: 9, answer: 3},
                    {a: 6, b: 9, answer: 3},
                    {a: 7, b: 22, answer: 1},
                    {a: 14, b: 21, answer: 7},
                ]
    }

    function test_getGGT(data) {
        var result = Vigenere.getGGT(data.a, data.b)
        compare(result, data.answer, "result getGGT Vigenere")
    }



    function test_getGGTFromList_data() {
        return [
                    {input: [1, 2, 3], answer: 1},
                    {input: [162, 639, 477], answer: 9},
                    {input: [5, 10], answer: 5},
                ]
    }

    function test_getGGTFromList(data) {
        var result = Vigenere.getGGTFromList(data.input)
        compare(result, data.answer, "result getGGTFromList Vigenere")
    }


    //not checking mark functions
}
