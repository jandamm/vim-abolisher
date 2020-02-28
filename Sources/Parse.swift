func parseLine(_ line: String) throws -> Abolish? {
	// Expect: "Abolish som{e,a} not{a,}
	guard line.hasPrefix("Abolish ") else { return nil }
	let parts = line.split(separator: " ")

	guard parts.count >= 3 else { throw AbolishError.malformatted }
	let pattern = parts[1]
	let replace = parts[2]

	return Abolish(
		pattern: try parsePart(pattern),
		replace: try parsePart(replace)
	)
}

func parsePart(_ part: Substring) throws -> Part {
	guard let nextOption = part.firstIndex(of: "{") else {
		return .part(part, next: nil)
	}
	let xyz = part[..<nextOption]
	if xyz.isEmpty {
		guard let optionEnd = part.firstIndex(of: "}") else {
			throw AbolishError.malformatted
		}
		return .option(
			try parseOption(part[nextOption ... optionEnd]),
			next: try parsePart(part[part.index(after: optionEnd)...]
			)
		)
	}
	return .part(xyz, next: try parsePart(part[nextOption...]))
}

func parseOption(_ option: Substring) throws -> [Substring] {
	// Expect: {some,else}
	guard option.hasPrefix("{"), option.hasSuffix("}") else { throw AbolishError.malformatted }
	return option.dropFirst().dropLast().split(separator: ",", omittingEmptySubsequences: false)
}
