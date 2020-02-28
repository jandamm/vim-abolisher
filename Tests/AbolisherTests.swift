@testable import Library
import XCTest

final class AbolisherTests: XCTestCase {
	func testFullExpansion() {
		// This is an example of a functional test case.
		// Use XCTAssert and related functions to verify your tests produce the correct
		// results.
		let input = "Abolish   contin{u,o,ou,uo}s{,ly}  contin{uou}s{}"
		let output = [
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
		]
		XCTAssertEqual(expand(abolisher: try! parseLine(input)!), output)
	}

	static var allTests = [
		("testFullExpansion", testFullExpansion),
	]
}
