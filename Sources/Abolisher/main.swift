import Foundation
import Library

func echo(_ str: String) { print(str) }
func echoErr(_ str: String) { FileHandle.standardError.write(Data(str.utf8)) }

do {
	try CommandLine.arguments.dropFirst()
		.map(URL.init(fileURLWithPath:))
		.map(String.init(contentsOf:))
		.map { $0.components(separatedBy: .newlines) }
		.flatMap(parse)
		.flatMap(expand(includeOtherLines: CommandLine.arguments.count <= 2))
		.forEach(echo)
} catch let Abolisher.Error.replaceMissing(line) {
	echoErr("There is no Replace detected in this line:\n\(line)")
} catch {
	throw error
}
