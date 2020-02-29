import Foundation
import Library

func echo(_ str: String) { print(str) }

try CommandLine.arguments.dropFirst()
	.map(URL.init(fileURLWithPath:))
	.map(String.init(contentsOf:))
	.map { $0.components(separatedBy: .newlines) }
	.flatMap(parse)
	.flatMap(expand)
	.forEach(echo)
