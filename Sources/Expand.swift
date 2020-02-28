func concat(_ first: (Substring, Substring), _ rest: [(Substring, Substring)]) -> [(Substring, Substring)] {
	if rest.isEmpty {
		return [first]
	}
	return rest.map { this in
		(
			first.0 + this.0,
			first.1 + this.1
		)
	}
}

extension StringProtocol {
	func capitalized() -> String {
		return first.map { $0.uppercased() + self.dropFirst() } ?? ""
	}
}

let iabbr = "iabbrev"
func expand(abolish: Abolish) -> [String] {
	return expand(pattern: abolish.pattern, replace: abolish.replace)
		.flatMap { abolish -> [String] in
			let pattern = abolish.0
			let replace = abolish.1
			return [
				"\(iabbr) \(pattern) \(replace)",
				"\(iabbr) \(pattern.capitalized()) \(replace.capitalized())",
				"\(iabbr) \(pattern.uppercased()) \(replace.uppercased())",
				"",
			]
		}
}

func expand(pattern: Part?, replace: Part?) -> [(Substring, Substring)] {
	guard let pattern = pattern, let replace = replace else {
		return []
	}
	switch (pattern, replace) {
	case let (.part(p, nextP), .part(r, nextR)):
		return concat((p, r), expand(pattern: nextP, replace: nextR))

	case let (.part(p, nextP), .option):
		return concat((p, ""), expand(pattern: nextP, replace: replace))

	case let (.option, .part(r, nextR)):
		return concat(("", r), expand(pattern: pattern, replace: nextR))

	case let (.option(ps, nextP), .option(rs, nextR)):
		let opt: [Substring]
		if rs == [""] {
			opt = ps
		} else if let f = rs.first, rs.count == 1 {
			opt = Array(repeating: f, count: ps.count)
		} else {
			opt = rs
		}

		return zip(ps, opt).flatMap { (p, r) -> [(Substring, Substring)] in
			concat((p, r), expand(pattern: nextP, replace: nextR))
		}
	}
}
