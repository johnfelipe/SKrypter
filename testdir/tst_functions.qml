import QtQuick 2.2
import QtTest 1.0

import CCode 1.0
import "../qml/exercises/alphabet.js" as Alphabet
import "../qml/common/Globals.js" as Globals


TestCase {
    name: "C++ Function Tests"

    //no test for createXGramMap as implicitely tested in calculateKasiskiXGrams tests

    //*******************calculateKasiskiXGrams tests**************

    function test_KasiskiXGrams_data() {
        return [
                    {text: "AAABB", from: 1, to: 1, max: 1, result: [["A", 3]]},
                    {text: "ABAB", from: 2, to: 2, max: 10, result: [["AB", 2]]},
                    {text: "A BAB AB", from: 2, to: 2, max: 10, result: [["AB", 2]]},
                    {text: "ABCAB", from: 2, to: 2, max: 10, result: [["AB", 2]]},
                    {text: "ABCABABC", from: 2, to: 2, max: 10, result: [["AB", 3, "BC", 2]]},

                    {text: "ABABAB", from: 1, to: 2, max: 2, result: [["AB", 3, "BA", 2], []]},
                    {text: "ABABABB", from: 1, to: 2, max: 2, result: [["AB", 3, "BA", 2], ["B", 4]]},
                    {text: "ABABABBDEFEGE", from: 1, to: 2, max: 2, result: [["AB", 3, "BA", 2], ["B", 4, "E", 3]]},
                    {text: "A AB AB A AB BA BA", from: 1, to: 2, max: 2, result: [["AB", 3, "BA", 2], ["A", 7, "B", 5]]},
                ]
    }

    function test_KasiskiXGrams(data) {
        //only returns xgrams that appear more than once!
        var list = Calculations.calculateKasiskiXGrams(data.text, data.from, data.to, data.max)

        compare(list, data.result, "list compare")
    }

    function test_KasiskiXGramsLong_data() {
        var text31_book = "Nlht Ltrvh nhr Hazhrxphrtvhr spqs tf Atqsu,
                    Wthzhr nhr Iyhlvhrshllwqshlr tr tslhr Soaahr ogw Wuhtr,
                    Nhr Wuhlzatqshr, hytv nhf Upnh bhljoaahr, rhgr,
                    Htrhl nhf Ngrxahr Shllr ogj ngrxahf Uslpr
                    Tf Aornh Fplnpl, yp nth Wqsouuhr nlpsr.
                    Htr Ltrv, wth ig xrhqsuhr, wth oaah ig jtrnhr,
                    Trw Ngrxha ig ulhtzhr grn hytv ig ztrnhr
                    Tf Aornh Fplnpl, yp nth Wqsouuhr nlpsr."

        return [
                    {text: Alphabet.cleanText(text31_book, false, " "), from: 2, to: 2, max: 5, length: 5*2, first: "HR", second: 19},
                    {text: Alphabet.cleanText(text31_book, false, " "), from: 3, to: 3, max: 3, length: 3*2, first: "NHR", second: 5},
                    {text: text31_book, from: 2, to: 2, max: 5, length: 5*2, first: "HR", second: 19},
                    {text: text31_book, from: 3, to: 3, max: 3, length: 3*2, first: "NHR", second: 5},
                ]
    }

    function test_KasiskiXGramsLong(data) {
        //only returns xgrams that appear more than once!
        var list = Calculations.calculateKasiskiXGrams(data.text, data.from, data.to, data.max)

        compare(list[0].length, data.length, "list.length")
        compare(list[0][0], data.first, "list[0]")
        compare(list[0][1], data.second, "list[1]")
    }


    //**************** calculateRelativeXGrams test *******

    function test_calculateRelativeXGrams_data() {
        return [
                    {text: "Ab", xgramLength: 2, max: 10, length: 1*2, first: "AB", second: 100},
                    {text: "aBC", xgramLength: 2, max: 10, length: 2*2, first: "AB", second: 50},
                    {text: "abCAb", xgramLength: 2, max: 10, length: 3*2, first: "AB", second: 50},
                    {text: "AB", xgramLength: 2, max: 10, length: 1*2, first: "AB", second: 100},
                    {text: "ABc", xgramLength: 2, max: 10, length: 2*2, first: "AB", second: 50},
                    {text: "ABCAB", xgramLength: 2, max: 10, length: 3*2, first: "AB", second: 50},
                ]
    }

    function test_calculateRelativeXGrams(data) {
        var list = Calculations.calculateRelativeXGrams(data.text, data.xgramLength, data.max)

        compare(list.length, data.length, "list.length")
        compare(list[0], data.first, "list[0]")
        compare(list[1], data.second, "list[1]")
    }

    //can't directly test calculateFrequencies cause of return type, will be tested in calculateFC

    function test_friedmanTest_data() {
        var text42_book = "QQFWe	MDCKQ	VKDUe	VeHQZ	KUTAT	QIDOW	GDGTR	PQVFD	QBAZW	UUAJU
    SRSIZ	OJSee	XYWBI	LWZRP	RXMCK	KQICP	VNZMK	FDXPW	OPSXQ	VDYKQ
    WJYQS	XYHQV	LKQTO	eaQZC	SZNSP	RMTLW	ZSRSe	QNWJG	MVPFD	IUZFH
    PMIZC	FVIaG	FQYQK	KYaeW	IPIKC	XUTRW	FMKUT	aUOID	PWJPe	QPKUV
    FLeIR	SJGMJ	VQNUL	PXHMa	ZTTCI	eaaWD	eCRPG	MUCXI	RSIDe	WaeEW
    LXSMG	jsesp	REKZS	RECGS	DOWDQ	STYYZ	LKGFR	XQJFa	aWPaH	VVUUa
    FMLXD	XUaUZ	QPGZF	XMEFU	CWEKM	VRMZV	DCFQZ	WaFEI	EVaBR	NUEaP
    VYQKK	HEGDX	MMFVZ	IHDIW	WEEQN	HTIPM	JEQNH	NLQVO	WXTBT	XUPJW
    DSRSE	RADGS	IZYEO	PMFPN	PNLMC	XVUEH	NLXQU	ZQUCO	ZQZXG	XGTYY
    ZMJTU	TIWMO	PVAQS	EFVPM	KLMEI	PVEHO	AECWP	RIMAV	QUCOH	AZXCU
    RRSIE	BWAXK	ATTBM	FMZDH	NLMMX	WDWPR	IZESJ	FECFR	SMSZZ	TTLFQ
    VLWGE	GLYRU	AKEMP	APQCF	VUHGP	lqzvw	NIHPW	UPFWZ	TPEWM	MUZXI
    RSKQT	AFSTA	TGTBA	FEDJY	OQTRM	NRXYK	qvmfp	DTYVM	MLKQL	WLJFM
    FLADX	SVQAK	UTATQ	IDASM	RZJVP	MMJWZ	"
        return [
                    {text: text42_book.toUpperCase(), fromKey: 5, toKey: 5, answer: [0.0494]},
                    {text: text42_book, fromKey: 5, toKey: 5, answer: [0.0494]},
                ]
    }

    //also tests calculateFC
    function test_friedmanTest(data) {
        var result = Calculations.friedmanTest(data.text, data.fromKey, data.toKey)
        for (var i=0; i<result.length; i++) {
            compare(Math.round(result[i]*10000)/10000, data.answer[i])
        }
    }

    function test_calculateFC() {
        var text42_book = "QQFWe	MDCKQ	VKDUe	VeHQZ	KUTAT	QIDOW	GDGTR	PQVFD	QBAZW	UUAJU
    SRSIZ	OJSee	XYWBI	LWZRP	RXMCK	KQICP	VNZMK	FDXPW	OPSXQ	VDYKQ
    WJYQS	XYHQV	LKQTO	eaQZC	SZNSP	RMTLW	ZSRSe	QNWJG	MVPFD	IUZFH
    PMIZC	FVIaG	FQYQK	KYaeW	IPIKC	XUTRW	FMKUT	aUOID	PWJPe	QPKUV
    FLeIR	SJGMJ	VQNUL	PXHMa	ZTTCI	eaaWD	eCRPG	MUCXI	RSIDe	WaeEW
    LXSMG	jsesp	REKZS	RECGS	DOWDQ	STYYZ	LKGFR	XQJFa	aWPaH	VVUUa
    FMLXD	XUaUZ	QPGZF	XMEFU	CWEKM	VRMZV	DCFQZ	WaFEI	EVaBR	NUEaP
    VYQKK	HEGDX	MMFVZ	IHDIW	WEEQN	HTIPM	JEQNH	NLQVO	WXTBT	XUPJW
    DSRSE	RADGS	IZYEO	PMFPN	PNLMC	XVUEH	NLXQU	ZQUCO	ZQZXG	XGTYY
    ZMJTU	TIWMO	PVAQS	EFVPM	KLMEI	PVEHO	AECWP	RIMAV	QUCOH	AZXCU
    RRSIE	BWAXK	ATTBM	FMZDH	NLMMX	WDWPR	IZESJ	FECFR	SMSZZ	TTLFQ
    VLWGE	GLYRU	AKEMP	APQCF	VUHGP	lqzvw	NIHPW	UPFWZ	TPEWM	MUZXI
    RSKQT	AFSTA	TGTBA	FEDJY	OQTRM	NRXYK	qvmfp	DTYVM	MLKQL	WLJFM
    FLADX	SVQAK	UTATQ	IDASM	RZJVP	MMJWZ	"

        var result = Calculations.calculateFC(text42_book)
        compare(Math.round(result*10000)/10000, 0.0432)

        result = Calculations.calculateFC(text42_book.toUpperCase())
        compare(Math.round(result*10000)/10000, 0.0432)
    }

    function test_sinkovTest_data() {
        var text42_book = "QQFWe	MDCKQ	VKDUe	VeHQZ	KUTAT	QIDOW	GDGTR	PQVFD	QBAZW	UUAJU
    SRSIZ	OJSee	XYWBI	LWZRP	RXMCK	KQICP	VNZMK	FDXPW	OPSXQ	VDYKQ
    WJYQS	XYHQV	LKQTO	eaQZC	SZNSP	RMTLW	ZSRSe	QNWJG	MVPFD	IUZFH
    PMIZC	FVIaG	FQYQK	KYaeW	IPIKC	XUTRW	FMKUT	aUOID	PWJPe	QPKUV
    FLeIR	SJGMJ	VQNUL	PXHMa	ZTTCI	eaaWD	eCRPG	MUCXI	RSIDe	WaeEW
    LXSMG	jsesp	REKZS	RECGS	DOWDQ	STYYZ	LKGFR	XQJFa	aWPaH	VVUUa
    FMLXD	XUaUZ	QPGZF	XMEFU	CWEKM	VRMZV	DCFQZ	WaFEI	EVaBR	NUEaP
    VYQKK	HEGDX	MMFVZ	IHDIW	WEEQN	HTIPM	JEQNH	NLQVO	WXTBT	XUPJW
    DSRSE	RADGS	IZYEO	PMFPN	PNLMC	XVUEH	NLXQU	ZQUCO	ZQZXG	XGTYY
    ZMJTU	TIWMO	PVAQS	EFVPM	KLMEI	PVEHO	AECWP	RIMAV	QUCOH	AZXCU
    RRSIE	BWAXK	ATTBM	FMZDH	NLMMX	WDWPR	IZESJ	FECFR	SMSZZ	TTLFQ
    VLWGE	GLYRU	AKEMP	APQCF	VUHGP	lqzvw	NIHPW	UPFWZ	TPEWM	MUZXI
    RSKQT	AFSTA	TGTBA	FEDJY	OQTRM	NRXYK	qvmfp	DTYVM	MLKQL	WLJFM
    FLADX	SVQAK	UTATQ	IDASM	RZJVP	MMJWZ	"
        return [
                    {text: text42_book, kd: 0.0773, Kg: Globals.kg, answer: 8.2839},
                    {text: text42_book.toUpperCase(), kd: 0.0773, Kg: Globals.kg, answer: 8.2839},
                ]
    }

    function test_sinkovTest(data) {
        var result = Calculations.sinkovTest(data.text, data.kd, data.Kg)
        console.log(result)
        //NOTE: the answer in the book on page 382 seems to have intermediate results rounded!!!
        //The program here is more exact!
        compare(Math.round(result*100)/100, Math.round(data.answer*100)/100)
    }


    /*
      Speed Test
    function test_speedTest() {
        var text = ""
        console.time("C++")
        Calculations.createXGramMapHelper(3, text)
        console.timeEnd("C++")
        console.time("JS")
        Alphabet.calculateXGramMap(text, 3)
        console.timeEnd("JS")
    }
    */
}
