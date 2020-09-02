@testable import Library
import XCTest

final class AbolisherTests: XCTestCase {
	func testCorrectPattern() throws {
		let input = "Abolish   {in,,dis}contin{u,o,ou,uo}s{,ly}  {}contin{uou}s{}"
		let output = [
			"iabbrev incontinus incontinuous",
			"iabbrev Incontinus Incontinuous",
			"iabbrev INCONTINUS INCONTINUOUS",
			"",
			"iabbrev incontinusly incontinuously",
			"iabbrev Incontinusly Incontinuously",
			"iabbrev INCONTINUSLY INCONTINUOUSLY",
			"",
			"iabbrev incontinos incontinuous",
			"iabbrev Incontinos Incontinuous",
			"iabbrev INCONTINOS INCONTINUOUS",
			"",
			"iabbrev incontinosly incontinuously",
			"iabbrev Incontinosly Incontinuously",
			"iabbrev INCONTINOSLY INCONTINUOUSLY",
			"",
			"iabbrev incontinous incontinuous",
			"iabbrev Incontinous Incontinuous",
			"iabbrev INCONTINOUS INCONTINUOUS",
			"",
			"iabbrev incontinously incontinuously",
			"iabbrev Incontinously Incontinuously",
			"iabbrev INCONTINOUSLY INCONTINUOUSLY",
			"",
			"iabbrev incontinuos incontinuous",
			"iabbrev Incontinuos Incontinuous",
			"iabbrev INCONTINUOS INCONTINUOUS",
			"",
			"iabbrev incontinuosly incontinuously",
			"iabbrev Incontinuosly Incontinuously",
			"iabbrev INCONTINUOSLY INCONTINUOUSLY",
			"",
			"iabbrev continus continuous",
			"iabbrev Continus Continuous",
			"iabbrev CONTINUS CONTINUOUS",
			"",
			"iabbrev continusly continuously",
			"iabbrev Continusly Continuously",
			"iabbrev CONTINUSLY CONTINUOUSLY",
			"",
			"iabbrev continos continuous",
			"iabbrev Continos Continuous",
			"iabbrev CONTINOS CONTINUOUS",
			"",
			"iabbrev continosly continuously",
			"iabbrev Continosly Continuously",
			"iabbrev CONTINOSLY CONTINUOUSLY",
			"",
			"iabbrev continous continuous",
			"iabbrev Continous Continuous",
			"iabbrev CONTINOUS CONTINUOUS",
			"",
			"iabbrev continously continuously",
			"iabbrev Continously Continuously",
			"iabbrev CONTINOUSLY CONTINUOUSLY",
			"",
			"iabbrev continuos continuous",
			"iabbrev Continuos Continuous",
			"iabbrev CONTINUOS CONTINUOUS",
			"",
			"iabbrev continuosly continuously",
			"iabbrev Continuosly Continuously",
			"iabbrev CONTINUOSLY CONTINUOUSLY",
			"",
			"iabbrev discontinus discontinuous",
			"iabbrev Discontinus Discontinuous",
			"iabbrev DISCONTINUS DISCONTINUOUS",
			"",
			"iabbrev discontinusly discontinuously",
			"iabbrev Discontinusly Discontinuously",
			"iabbrev DISCONTINUSLY DISCONTINUOUSLY",
			"",
			"iabbrev discontinos discontinuous",
			"iabbrev Discontinos Discontinuous",
			"iabbrev DISCONTINOS DISCONTINUOUS",
			"",
			"iabbrev discontinosly discontinuously",
			"iabbrev Discontinosly Discontinuously",
			"iabbrev DISCONTINOSLY DISCONTINUOUSLY",
			"",
			"iabbrev discontinous discontinuous",
			"iabbrev Discontinous Discontinuous",
			"iabbrev DISCONTINOUS DISCONTINUOUS",
			"",
			"iabbrev discontinously discontinuously",
			"iabbrev Discontinously Discontinuously",
			"iabbrev DISCONTINOUSLY DISCONTINUOUSLY",
			"",
			"iabbrev discontinuos discontinuous",
			"iabbrev Discontinuos Discontinuous",
			"iabbrev DISCONTINUOS DISCONTINUOUS",
			"",
			"iabbrev discontinuosly discontinuously",
			"iabbrev Discontinuosly Discontinuously",
			"iabbrev DISCONTINUOSLY DISCONTINUOUSLY",
			"",
		]
		XCTAssertEqual(expandAbolisher(try parseLine(input), includeOtherLines: false), output)
	}

	func testNoAbolishLine() throws {
		let input1 = "Abolsh   contin{u,o,ou,uo}s{,ly}  contin{uou}s{}"
		let input2 = "iabbrev abc def"
		let parse1 = try parseLine(input1)
		let parse2 = try parseLine(input2)
		XCTAssertEqual(parse1, Abolisher(input: input1, type: .line))
		XCTAssertEqual(parse2, Abolisher(input: input2, type: .line))
		XCTAssertEqual(expand(parse1, includeOtherLines: false), [])
		XCTAssertEqual(expand(parse2, includeOtherLines: false), [])
		XCTAssertEqual(expand(parse1, includeOtherLines: true), [input1])
		XCTAssertEqual(expand(parse2, includeOtherLines: true), [input2])
	}

	func testMissingReplace() throws {
		let input = "Abolish some "
		do {
			_ = try parseLine(input)
			XCTFail("Should not be parsed successfully")
		} catch let Abolisher.Error.replaceMissing(line) {
			XCTAssertEqual(line, input)
		} catch {
			throw error
		}
	}

	func testReplaceWithSpaces() throws {
		let input = "Abolish some else more stuff "
		XCTAssertEqual(
			try parseLine(input),
			Abolisher(input: input, type: .abolish(pattern: .part("some", next: nil), replace: .part("else more stuff ", next: nil)))
		)
	}

	func testMismatchingOptions() throws {
		do {
			let lessPattern = expandAbolisher(try parseLine("Abolish s{a,b} e{c,d,e}"), includeOtherLines: false)
			let lessReplace = expandAbolisher(try parseLine("Abolish s{a,b,c} e{d,e}"), includeOtherLines: false)
			let emptPattern = expandAbolisher(try parseLine("Abolish s{a,b} e{}"), includeOtherLines: false)
			let emptReplace = expandAbolisher(try parseLine("Abolish s{} e{a,b,c}"), includeOtherLines: false)
			let onePattern = expandAbolisher(try parseLine("Abolish s{a} e{b,c,d}"), includeOtherLines: false)
			let oneReplace = expandAbolisher(try parseLine("Abolish s{a,b} e{c}"), includeOtherLines: false)

			XCTAssertEqual(lessPattern[0], "iabbrev sa ec")
			XCTAssertEqual(lessPattern[4], "iabbrev sb ed")
			XCTAssertEqual(lessPattern.count, 8)

			XCTAssertEqual(lessReplace[0], "iabbrev sa ed")
			XCTAssertEqual(lessReplace[4], "iabbrev sb ee")
			XCTAssertEqual(lessReplace[8], "iabbrev sc ed")
			XCTAssertEqual(lessReplace.count, 12)

			XCTAssertEqual(emptPattern[0], "iabbrev sa ea")
			XCTAssertEqual(emptPattern[4], "iabbrev sb eb")
			XCTAssertEqual(emptPattern.count, 8)

			XCTAssertEqual(emptReplace[0], "iabbrev s ea")
			XCTAssertEqual(emptReplace.count, 4)

			XCTAssertEqual(onePattern[0], "iabbrev sa eb")
			XCTAssertEqual(onePattern.count, 4)

			XCTAssertEqual(oneReplace[0], "iabbrev sa ec")
			XCTAssertEqual(oneReplace[4], "iabbrev sb ec")
			XCTAssertEqual(oneReplace.count, 8)

		} catch {
			throw error
		}
	}

	func testMismatchingOptionCount() throws {
		do {
			let expandA = expandAbolisher(try parseLine("Abolish some{a,b} el{}se{a,b}a{x}"), includeOtherLines: false).first!
			let expandB = expandAbolisher(try parseLine("Abolish some el{}se{a,b}a{x}"), includeOtherLines: false).first!
			XCTAssertEqual(expandA, "iabbrev somea elase{a,b}a{x}")
			XCTAssertEqual(expandB, "iabbrev some el{}se{a,b}a{x}")
		} catch {
			throw error
		}
		do {
			let expands = expandAbolisher(try parseLine("Abolish so{a}me{a,b}a{x} else{b}"), includeOtherLines: false)
			XCTAssertEqual(expands[0], "iabbrev soameaax elseb")
			XCTAssertEqual(expands[4], "iabbrev soamebax elseb")
		} catch {
			throw error
		}
	}

	func testEmptyPatternOption() throws {
		XCTAssertEqual(
			expandAbolisher(try parseLine("Abolish so{}me else{a}"), includeOtherLines: false),
			[
				"iabbrev some elsea",
				"iabbrev Some Elsea",
				"iabbrev SOME ELSEA",
				"",
			]
		)
	}

	func testMissingBracket() throws {
		let part = parsePart("abs{ar,bs")
		XCTAssertEqual(
			part,
			.part("abs", next: .part("{ar,bs", next: nil))
		)
		XCTAssertEqual(
			expand(pattern: part, replace: nil).first!.0,
			"abs{ar,bs"
		)
	}

	func testFullOutput() throws {
		let input = [
			"Abolish s{o}me else{}",
			"Abolish s{u}me else{}",
		]

		let parsed = try parse(input)

		XCTAssertEqual(
			parsed.map(expand(includeOtherLines: false)),
			[
				[
					"\" \(input.first!)",
					"iabbrev some elseo",
					"iabbrev Some Elseo",
					"iabbrev SOME ELSEO",
					"",
				],
				[
					"\" \(input.last!)",
					"iabbrev sume elseu",
					"iabbrev Sume Elseu",
					"iabbrev SUME ELSEU",
					"",
				],
			]
		)
	}

	static var allTests = [
		("testCorrectPattern", testCorrectPattern),
		("testNoAbolishLine", testNoAbolishLine),
		("testMissingReplace", testMissingReplace),
		("testReplaceWithSpaces", testReplaceWithSpaces),
		("testMismatchingOptions", testMismatchingOptions),
		("testMismatchingOptionCount", testMismatchingOptionCount),
		("testEmptyPatternOption", testEmptyPatternOption),
		("testFullOutput", testFullOutput),
	]
}
