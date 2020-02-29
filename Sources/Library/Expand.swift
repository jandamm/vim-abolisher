func combine(_ first: (Substring, Substring), _ rest: [(Substring, Substring)]) -> [(Substring, Substring)] {
	rest.isEmpty
		? [first]
		: rest.map { this in
			(
				first.0 + this.0,
				first.1 + this.1
			)
		}
}

extension StringProtocol {
	func capitalized() -> String {
		first.map { $0.uppercased() + self.dropFirst() } ?? ""
	}
}

public func expand(_ abolisher: Abolisher) throws -> [String] {
	let abbrevs = try expandAbolisher(abolisher)
	return expandInput(abolisher.input) + abbrevs

}

func expandAbolisher(_ abolisher: Abolisher) throws -> [String] {
	try expand(pattern: abolisher.pattern, replace: abolisher.replace)
	.flatMap(getVariations)
}

func expandInput(_ input: String) -> [String] {
	return ["\" \(input)"]
}

func expand(pattern: Abolisher.Part?, replace: Abolisher.Part?) throws -> [(Substring, Substring)] {
	switch (pattern, replace) {
	case (.none, .none):
		return []

	case (.option, .none):
		throw Abolisher.Error.missingReplaceOptions

	case (.none, .option):
		throw Abolisher.Error.missingPatternOptions

	case let (.part(pattern, nextPattern), .part(replace, nextReplace)):
		return combine((pattern, replace), try expand(pattern: nextPattern, replace: nextReplace))

	case let (.part(pattern, nextPattern), .option),
	     let (.part(pattern, nextPattern), .none):
		return combine((pattern, ""), try expand(pattern: nextPattern, replace: replace))

	case let (.option, .part(replace, nextReplace)),
	     let (.none, .part(replace, nextReplace)):
		return combine(("", replace), try expand(pattern: pattern, replace: nextReplace))

	case let (.option(patterns, nextPattern), .option(replaces, nextReplace)):
		let opt: [Substring]
		let replacesCount = replaces.count
		if replaces == [""] {
			opt = patterns
		} else if let singleReplace = replaces.first, replacesCount == 1 {
			opt = Array(repeating: singleReplace, count: patterns.count)
		} else {
			let patternsCount = patterns.count
			if patternsCount != replacesCount {
				throw Abolisher.Error.mismatchingOptions(pat: patternsCount, rep: replacesCount)
			}
			opt = replaces
		}

		return try zip(patterns, opt)
			.flatMap { (pattern, replace) -> [(Substring, Substring)] in
				combine((pattern, replace), try expand(pattern: nextPattern, replace: nextReplace))

			}
	}
}

func getVariations(_ parts: (Substring, Substring)) -> [String] {
	let pattern = parts.0
	let replace = parts.1
	return [
		"iabbrev \(pattern) \(replace)",
		"iabbrev \(pattern.capitalized()) \(replace.capitalized())",
		"iabbrev \(pattern.uppercased()) \(replace.uppercased())",
		"",
	]
}
