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
		XCTAssertEqual(try expandAbolisher(try parseLine(input)!), output)
	}

	func testNoAbolishLine() {
		let input = "Abolsh   contin{u,o,ou,uo}s{,ly}  contin{uou}s{}"
		XCTAssertNil(try parseLine(input))
	}

	func testMissingReplace() throws {
		do {
			_ = try parseLine("Abolish some ")
			XCTFail("Should not be parsed")
		} catch Abolisher.Error.replaceMissing {
			// success
		} catch {
			throw error
		}
	}

	func testTextAfterReplace() throws {
		let input = "Abolish some else more stuff"
		XCTAssertEqual(
			try parseLine(input),
			Abolisher(input: input, pattern: .part("some", next: nil), replace: .part("else", next: nil))
		)
	}

	func testMismatchingOptions() throws {
		do {
			_ = try expandAbolisher(try parseLine("Abolish some{a,b} else{a,b,c}")!)
			XCTFail("Should not be parsed")
		} catch Abolisher.Error.mismatchingOptions(pat: 2, rep: 3) {
			// success
		} catch {
			throw error
		}
	}

	func testMismatchingOptionCount() throws {
		do {
			_ = try expandAbolisher(try parseLine("Abolish some{a,b} el{}se{a,b}")!)
			XCTFail("Should not be parsed")
		} catch Abolisher.Error.missingPatternOptions {
			// success
		} catch {
			throw error
		}
		do {
			_ = try expandAbolisher(try parseLine("Abolish so{a}me{a,b} else{a}")!)
			XCTFail("Should not be parsed")
		} catch Abolisher.Error.missingReplaceOptions {
			// success
		} catch {
			throw error
		}
	}

	func testEmptyPatternOption() throws {
		// What would I expect here?
		XCTAssertEqual(
			try expandAbolisher(try parseLine("Abolish so{}me else{a}")!),
			[
				"iabbrev some elsea",
				"iabbrev Some Elsea",
				"iabbrev SOME ELSEA",
				"",
			]
		)
	}

	func testMissingBracket() throws {
		do {
			_ = try parsePart("abs{ar,bs")
			XCTFail("Should not be parsed")
		} catch Abolisher.Error.missingClosingBracket {
			// success
		} catch {
			throw error
		}
	}

	func testFullOutput() throws {
		let input = [
			"Abolish s{o}me else{}",
			"Abolish s{u}me else{}",
			]

		let parsed = try parse(input)

		XCTAssertEqual(
			try parsed.map(expand),
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
			]
			]
		)
	}

	static var allTests = [
		("testCorrectPattern", testCorrectPattern),
		("testNoAbolishLine", testNoAbolishLine),
		("testMissingReplace", testMissingReplace),
		("testTextAfterReplace", testTextAfterReplace),
		("testMismatchingOptions", testMismatchingOptions),
		("testMismatchingOptionCount", testMismatchingOptionCount),
		("testEmptyPatternOption", testEmptyPatternOption),
		("testFullOutput", testFullOutput),
	]
}
