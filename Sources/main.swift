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

let abo = try! parseLine("Abolish contin{u,o,ou,uo}s{,ly} contin{uou}s{}")

dump(expand(abolish: abo!))
