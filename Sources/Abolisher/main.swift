import Foundation
import Library

func echo(_ str: String) { print(str) }
func echoErr(_ str: String) { FileHandle.standardError.write(Data(str.utf8)) }

let arguments = CommandLine.arguments.dropFirst()
do {
	try arguments
		.map(URL.init(fileURLWithPath:))
		.map(String.init(contentsOf:))
		.map { $0.components(separatedBy: .newlines) }
		.flatMap(parse)
		.flatMap(expand(includeOtherLines: arguments.count == 1))
		.forEach(echo)
} catch let Abolisher.Error.replaceMissing(line) {
	echoErr("There is no Replace detected in this line:\n\(line)")
} catch {
	echoErr((error as NSError).localizedDescription)
}
