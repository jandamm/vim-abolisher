struct Abolisher: Equatable {
	let input: String
	let pattern: Part
	let replace: Part

	indirect enum Part: Equatable {
		case part(Substring, next: Part?)
		case option([Substring], next: Part?)
	}

	enum Error: Swift.Error, Equatable {
		case replaceMissing
		case missingClosingBracket
		case mismatchingOptions(pat: Int, rep: Int)
		case missingReplaceOptions
		case missingPatternOptions
	}
}
