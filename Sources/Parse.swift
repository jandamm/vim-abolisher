func parseLine(_ line: String) throws -> Abolisher? {
	guard line.hasPrefix("Abolish ") else { return nil }

	let parts = line.split(separator: " ")

	guard parts.count >= 3 else { throw Abolisher.Error.replaceMissing }

	return Abolisher(
		input: line,
		pattern: try parsePart(parts[1]),
		replace: try parsePart(parts[2])
	)
}

func parsePart(_ part: Substring) throws -> Abolisher.Part {
	switch part.firstIndex(of: "{") {
	case part.startIndex:
		guard let optionEndIndex = part.firstIndex(of: "}") else {
			throw Abolisher.Error.missingClosingBracket
		}
		return .option(
			try parseOption(part[...optionEndIndex]),
			next: try parsePart(part[part.index(after: optionEndIndex)...]
			)
		)
	case let nextOptionIndex?:
		return .part(part[..<nextOptionIndex], next: try parsePart(part[nextOptionIndex...]))
	case nil:
		return .part(part, next: nil)
	}
}

func parseOption(_ option: Substring) throws -> [Substring] {
	option
		.dropFirst()
		.dropLast()
		.split(separator: ",", omittingEmptySubsequences: false)
}
