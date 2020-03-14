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

public func expand(includeOtherLines: Bool) -> (_ abolisher: Abolisher) -> [String] {
	return { abolisher in expand(abolisher, includeOtherLines: includeOtherLines) }
}

public func expand(_ abolisher: Abolisher, includeOtherLines: Bool) -> [String] {
	expandAbolisherComment(abolisher)
		+ expandAbolisher(abolisher, includeOtherLines: includeOtherLines)
}

func expandAbolisher(_ abolisher: Abolisher, includeOtherLines: Bool) -> [String] {
	switch abolisher.type {
	case let .abolish(pattern, replace):
		return expand(pattern: pattern, replace: replace)
			.flatMap(getVariations)
	case .line where includeOtherLines:
		return [abolisher.input]
	case .line:
		return []
	}
}

func expandAbolisherComment(_ abolisher: Abolisher) -> [String] {
	switch abolisher.type {
	case .abolish:
		return ["\" \(abolisher.input)"]
	case .line:
		return []
	}
}

func expand(pattern: Abolisher.Part?, replace: Abolisher.Part?) -> [(Substring, Substring)] {
	switch (pattern, replace) {
	case (.none, .none):
		return []

	case let (.option(pattern, nextPattern), .none):
		return pattern.flatMap {
			combine(($0, ""), expand(pattern: nextPattern, replace: nil))
		}

	case let (.none, .option(replace, nextReplace)):
		return combine(("", "{\(replace.joined(separator: ","))}"), expand(pattern: nil, replace: nextReplace))

	case let (.part(pattern, nextPattern), .part(replace, nextReplace)):
		return combine((pattern, replace), expand(pattern: nextPattern, replace: nextReplace))

	case let (.part(pattern, nextPattern), .option),
	     let (.part(pattern, nextPattern), .none):
		return combine((pattern, ""), expand(pattern: nextPattern, replace: replace))

	case let (.option, .part(replace, nextReplace)),
	     let (.none, .part(replace, nextReplace)):
		return combine(("", replace), expand(pattern: pattern, replace: nextReplace))

	case let (.option(patterns, nextPattern), .option(replaces, nextReplace)):
		let options = replaces == [""]
			? patterns
			: replaces
		let optionsCount = options.count

		return patterns
			.enumerated()
			.flatMap { (index, pattern) -> [(Substring, Substring)] in
				combine((pattern, options[index % optionsCount]), expand(pattern: nextPattern, replace: nextReplace))
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
