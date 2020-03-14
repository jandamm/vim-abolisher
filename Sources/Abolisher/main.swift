import Foundation
import Library

func echo(_ str: String) { print(str) }
func echoErr(_ str: String) { FileHandle.standardError.write(Data(str.utf8)) }

func main() {
	let arguments = CommandLine.arguments.dropFirst()

	guard !arguments.isEmpty else {
		echo(
			"""
			This command will expand every "Abolish some thing" in the provided file and print it to stdout.

			Use it like this: "abolisher my_file > my_expanded_file"

			Provide one or more files.
			- If you pass one file the whole content plus the expanded Abolish are expanded.
			- If you pass more than one file only Abolish lines are expanded
			"""
		)
		return
	}

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
}

main()
