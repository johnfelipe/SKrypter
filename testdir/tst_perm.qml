import QtQuick 2.2
import QtTest 1.0

import "../qml/exercises/perm/Perm.js" as Perm
import "../qml/exercises/alphabet.js" as Alphabet

TestCase {
    name: "Perm Tests"


    ListModel {
        id: alphabetically_ordered_model
    }

    ListModel {
        id: randomly_ordered_model
    }

    function test_cryptPerm_data() {
        var dummyMapping = []
        for (var i=0; i<26; i++) {
            dummyMapping[i] = i
        }

        var key = "PMHKSLCQARUEDYIFOJGBWVZXNT"
        var mapping = Alphabet.stringKeyToIndexKey(key, true)

        return [
                    {text: "ABC", mapping: dummyMapping, answer: "ABC"},
                    {text: "Das ist ein Test! Sonderzeiçhen?", mapping: dummyMapping, answer: "Das ist ein Test! Sonderzeiçhen?"},
                    {text: "Angenehm ist am Gegenwaertigen die Taetigkeit am Kuenftigen die Hoffnung und am Vergangenen die Erinnerung Am angenehmsten und in gleichem Mae liebenswert ist das Taetigsein Aristoteles", mapping: mapping, answer: "Pycsysqd agb pd Cscsyzpsjbacsy kas Bpsbacusab pd Uwsylbacsy kas Qillywyc wyk pd Vsjcpycsysy kas Sjayysjwyc Pd pycsysqdgbsy wyk ay cesahqsd Dps easmsygzsjb agb kpg Bpsbacgsay Pjagbibsesg"},
                ]
    }

    function test_cryptPerm(data) {
        var result = Perm.crypt(data.text, data.mapping)
        compare(result, data.answer, "crypt result")
    }

    function test_check_data() {
        Alphabet.createOrUpdateAlphabet(alphabetically_ordered_model, false)
        Alphabet.createOrUpdateAlphabet(randomly_ordered_model, false)
        Alphabet.sortModelRandomly(randomly_ordered_model)
        var pt = "Dies ist ein Test"

        var ordered_mapping = []
        for (var i=0; i<26; i++) {
            ordered_mapping[i] = Alphabet.charCodeToIndex(alphabetically_ordered_model.get(i).letter.charCodeAt(0))
        }

        var random_mapping = []
        for (var i=0; i<26; i++) {
            random_mapping[i] = Alphabet.charCodeToIndex(randomly_ordered_model.get(i).letter.charCodeAt(0))
        }

        var ct_ordered = Perm.crypt(pt, ordered_mapping)
        var ct_random = Perm.crypt(pt, random_mapping)


        //var ct_random = Perm.crypt(pt, randomly_ordered_model)
        return [
                {plaintext: pt, ciphertext: ct_ordered, model: alphabetically_ordered_model, isEncrypt: true, answer: true},
                {plaintext: pt, ciphertext: ct_ordered, model: alphabetically_ordered_model, isEncrypt: false, answer: true},
                    //model can be used for en and decryption as it just maps A=A, B=B,...
                {plaintext: pt, ciphertext: ct_random, model: randomly_ordered_model, isEncrypt: true, answer: true},
                {plaintext: pt, ciphertext: ct_random, model: randomly_ordered_model, isEncrypt: false, answer: false},
                    //because the model is an encryption model!
                ]
    }

    function test_check(data) {
        var result = Perm.check(data.plaintext, data.ciphertext, data.model, data.isEncrypt)
        compare(result, data.answer)
    }

    //not necessary to test function checkKey

    //too much work to test function getMapping (also used in quite a few places, so would be noticeable)
    //same for getFullMapping

    function test_getSimpleMapping_data() {
        var key = "QWERTZUIOPLKJHGFDSAYXCVBNM"
        var mapping = Perm.getMappingFromKey(key)

        randomly_ordered_model.clear()
        for (var i=0; i<mapping.length; i++) {
            randomly_ordered_model.append({"letter":key[i]});
        }

        return [
                {model: randomly_ordered_model, answer: mapping},
                ]
    }

    function test_getSimpleMapping(data) {
        var result = Perm.getSimpleMapping(data.model)
        compare(result, data.answer)
    }

    //so far only test for ordered base which should not change mapping
    function test_getMappingForUnorderedBase_data() {
        var key = "QWERTZUIOPLKJHGFDSAYXCVBNM"
        var mapping = Perm.getMappingFromKey(key)
        alphabetically_ordered_model.clear()
        Alphabet.createOrUpdateAlphabet(alphabetically_ordered_model, false)

        return [
                {model: alphabetically_ordered_model, mapping: mapping, answer: mapping},
                ]
    }

    function test_getMappingForUnorderedBase(data) {
        var result = Perm.getMappingForUnorderedBase(data.model, data.mapping)
        compare(result, data.answer)
    }

    //not testing setMapping

    //tests both getKeyFromMapping and getMappingFromKey
    function test_getKeyFromMapping_data() {
        var key1 = "QWERTZUIOPLKJHGFDSAYXCVBNM"
        var key2 = "ABC"

        return [
                {mapping: Perm.getMappingFromKey(key1), answer: key1},
                   {mapping: Perm.getMappingFromKey(key2), answer: key2},
                ]
    }

    function test_getKeyFromMapping(data) {
        var result = Perm.getKeyFromMapping(data.mapping)
        compare(result, data.answer)
    }

    //not testing generateKeyString, hasLockedLetters and
    //setLockedLetters function due to repeater

    //not testing markGivenLetters

    function test_createPartialPlaintext_data() {
        return [
                {text: "abc", lockedPositions: "10000000000000000000000000", answer: "a__"},

                ]
    }

    function test_createPartialPlaintext(data) {
        var result = Perm.createPartialPlaintext(data.text, data.lockedPositions)
        compare(result, data.answer)
    }


    //not testing calculatePTModel

    function test_findNumberOfXgrams_data() {
        return [
                    {text: "Dies ist ein Test", length: 1, answer: 14},
                    {text: "Dies ist ein Test", length: 2, answer: 10},
                    {text: "Dies ist ein Test", length: 3, answer: 6},
                    {text: "Dies ist ein Test", length: 4, answer: 2},
                    {text: "Dies ist ein Test", length: 5, answer: 0},

                ]
    }

    function test_findNumberOfXgrams(data) {
        var result = Perm.findNumberOfXgrams(data.text, data.length)
        compare(result, data.answer)
    }

}
