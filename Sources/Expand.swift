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

func expand(abolisher: Abolisher) -> [String] {
	expand(pattern: abolisher.pattern, replace: abolisher.replace)
		.flatMap(getVariations)
}

func expand(pattern: Abolisher.Part?, replace: Abolisher.Part?) -> [(Substring, Substring)] {
	guard let pattern = pattern,
		let replace = replace else {
		return []
	}

	switch (pattern, replace) {
	case let (.part(pattern, nextPattern), .part(replace, nextReplace)):
		return combine((pattern, replace), expand(pattern: nextPattern, replace: nextReplace))

	case let (.part(pattern, nextPattern), .option):
		return combine((pattern, ""), expand(pattern: nextPattern, replace: replace))

	case let (.option, .part(replace, nextReplace)):
		return combine(("", replace), expand(pattern: pattern, replace: nextReplace))

	case let (.option(patterns, nextPattern), .option(replaces, nextReplace)):
		let opt: [Substring]
		if replaces == [""] {
			opt = patterns
		} else if let onlyReplace = replaces.first, replaces.count == 1 {
			opt = Array(repeating: onlyReplace, count: patterns.count)
		} else {
			opt = replaces
		}

		return zip(patterns, opt)
			.flatMap { (pattern, replace) -> [(Substring, Substring)] in
				combine((pattern, replace), expand(pattern: nextPattern, replace: nextReplace))
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
