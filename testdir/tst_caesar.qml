import QtQuick 2.2
import QtTest 1.0

import "../qml/exercises/caesar/Caesar.js" as Caesar

TestCase {
    name: "Caesar Tests"

    //CRYPT
    function test_cryptCaesar_data() {
        return [
                    {text: "ABC", key: 1, isEncrypt: true, answer: "BCD"},
                    {text: "ABC", key: 1, isEncrypt: false, answer: "ZAB"},
                    {text: "Das ist ein Test! Sonderzeiçhen?", key: 6, isEncrypt: true, answer: "Jgy oyz kot Zkyz! Yutjkxfkoçnkt?"},
                    {text: "Jgy oyz kot Zkyz! Yutjkxfkoçnkt?", key: 6, isEncrypt: false, answer: "Das ist ein Test! Sonderzeiçhen?"},
                ]
    }

    function test_cryptCaesar(data) {
        var result = Caesar.crypt(data.text, data.key, data.isEncrypt)
        compare(result, data.answer, "crypt result")
    }

    //CHECK
    function test_checkCaesar_data() {
        return [
                {plaintext: "ABC", ciphertext: "BCD", key: 1, answer: true},
                {plaintext: "Das ist ein Test! Sonderzeiçhen?", ciphertext: "Jgy oyz kot Zkyz! Yutjkxfkoçnkt?", key: 6, answer: true},
                {plaintext: "Annapurna", ciphertext: "Boobqwsob", key: 1, answer: false},
                {plaintext: "ABCD", ciphertext: "CDEG", key: 2, isEncrypt: true, answer: false},
                {plaintext: "ABCD", ciphertext: "CDEF", key: 2, isEncrypt: true, answer: true},
        ]
    }

    function test_checkCaesar(data) {
        var result = Caesar.check(data.plaintext, data.ciphertext, data.key)
        compare(result, data.answer, "check result")
    }

    function test_checkKey_data() {
        return [
                {key: 1, plain: "A", cipher: "B", answer: true},
                {key: 1, plain: "A", cipher: "C", answer: false},
                ]
    }

    function text_checkKey(data) {
        var result = Caesar.checkKey(data.key, data.plain, data.cipher)
        compare(key, data.answer)
    }

    function test_calculateFrequencies_data() {
        return [
                {text: "abcdefghijklmnopqrstuvwxyz", answer: [1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26,1.0/26]},
                {text: "aaa", answer: [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]},
                {text: "", answer: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]},
                {text: "dies ist ein test", answer: [0,0,0,1.0/14,3.0/14,0,0,0,3.0/14,0,0,0,0,1.0/14,0,0,0,0,3.0/14,3.0/14,0,0,0,0,0,0]},
                ]
    }

    function test_calculateFrequencies(data) {
        var result = Caesar.calculateFrequencies(data.text)
        compare(result, data.answer)
    }

    function test_createModelFromFrequencies_data() {
        return [
                {text: "dies ist ein test"},
                {text: "aaa"},
                {text: ""},
                ]
    }

    function test_createModelFromFrequencies(data) {
        var frequencies = Caesar.calculateFrequencies(data.text)
        var result = Caesar.createModelFromFrequencies(frequencies)
        for (var i=0; i<result.count; i++) {
            compare(result.get(i).letter, Alphabet.indexToUpperString(i))
            compare(result.get(i).percentage, frequencies[i])
        }
    }

    function test_checkFrequency_data() {
        return [
                {text: "AaaBbbCcc", userResult: "ABC", answer: true},
                {text: "AaaBbbCcc", userResult: "ACB", answer: true},
                {text: "Aaa", userResult: "ABC", answer: true},
                {text: "Aaa", userResult: "AXY", answer: true},
                {text: "Tritratrallala", userResult: "ALR", answer: true},
                {text: "ABCD", userResult: "BDCA", answer: true},
                {text: "aABCD", userResult: "ABDC", answer: true},
                {text: "aaaABbbCcD", userResult: "ABCD", answer: true},
                {text: "", userResult: "ABDC", answer: true},
                ]
    }

    function test_checkFrequency(data) {
        var result = Caesar.checkFrequency(data.text, data.userResult)
        compare(result, data.answer)
    }

    function test_getKeyFromLetters_data() {
        return [
                    {plain: "A", cipher: "B", answer: 1 },
                    {plain: "B", cipher: "A", answer: 25 },
                    {plain: "A", cipher: "A", answer: 0 },
                ]
    }

    function test_getKeyFromLetters(data) {
        var key = Caesar.getKeyFromLetters(data.plain, data.cipher)
        compare(key, data.answer)
    }
}
