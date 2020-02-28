struct Abolish {
	let pattern: Part
	let replace: Part
}

indirect enum Part {
	case part(Substring, next: Part?)
	case option([Substring], next: Part?)
}

enum AbolishError: Error {
	case malformatted
}
