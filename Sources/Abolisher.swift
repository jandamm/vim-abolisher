struct Abolisher {
	let input: String
	let pattern: Part
	let replace: Part

	indirect enum Part {
		case part(Substring, next: Part?)
		case option([Substring], next: Part?)
	}

	enum Error: Swift.Error {
		case replaceMissing
		case missingClosingBracket
	}
}
