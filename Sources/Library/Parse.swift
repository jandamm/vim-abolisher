public func parse(_ lines: [String]) throws -> [Abolisher] {
	try lines.map(parseLine)
}

let linePrefix = "Abolish "
let linePrefixLength = linePrefix.count

func parseLine(_ line: String) throws -> Abolisher {
	guard line.hasPrefix(linePrefix) else {
		return Abolisher(input: line, type: .line)
	}

	guard let (pattern, replace) = getParts(of: line) else { throw Abolisher.Error.replaceMissing(line: line) }

	return Abolisher(
		input: line,
		type: .abolish(
			pattern: parsePart(pattern),
			replace: parsePart(replace)
		)
	)
}

func getParts(of line: String) -> (pattern: Substring, replace: Substring)? {
	let line = line.dropFirst(linePrefixLength).drop { $0 == " " } // Drop 'Abolish *'

	guard let patternEnd = line.firstIndex(of: " ") else { return nil }
	let pattern = line[..<patternEnd]

	guard let replaceStart = line[patternEnd...].firstIndex(where: { $0 != " " }) else { return nil }

	return (pattern, line[replaceStart...])
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
