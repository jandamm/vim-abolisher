public func parse(_ lines: [String]) throws -> [Abolisher] {
	try lines.compactMap(parseLine)
}

func parseLine(_ line: String) throws -> Abolisher? {
	guard line.hasPrefix("Abolish ") else { return nil }

	let parts = line.split(separator: " ")

	guard parts.count >= 3 else { throw Abolisher.Error.replaceMissing }

	return Abolisher(
		input: line,
		pattern: parsePart(parts[1]),
		replace: parsePart(parts[2])
	)
}

func parsePart(_ part: Substring) -> Abolisher.Part {
	switch part.firstIndex(of: "{") {
	case part.startIndex:
		guard let optionEndIndex = part.firstIndex(of: "}") else {
			return .part(part, next: nil)
		}
		return .option(
			parseOption(part[...optionEndIndex]),
			next: parsePart(part[part.index(after: optionEndIndex)...]
			)
		)
	case let nextOptionIndex?:
		return .part(part[..<nextOptionIndex], next: parsePart(part[nextOptionIndex...]))
	case nil:
		return .part(part, next: nil)
	}
}

func parseOption(_ option: Substring) -> [Substring] {
	option
		.dropFirst()
		.dropLast()
		.split(separator: ",", omittingEmptySubsequences: false)
}
