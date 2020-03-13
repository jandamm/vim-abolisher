public struct Abolisher: Equatable {
	internal let input: String
	internal let type: Case

	enum Case: Equatable {
		case abolish(pattern: Part, replace: Part)
		case line
	}

	internal indirect enum Part: Equatable {
		case part(Substring, next: Part?)
		case option([Substring], next: Part?)
	}

	public enum Error: Swift.Error, Equatable {
		case replaceMissing(line: String)
	}
}
