// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Abolisher",
	products: [
		.executable(name: "abolisher", targets: ["Abolisher"]),
		.library(name: "Library", targets: ["Library"]),
	],
	dependencies: [],
	targets: [
		.target(
			name: "Abolisher",
			dependencies: ["Library"]
		),
		.target(
			name: "Library",
			dependencies: []
		),
		.testTarget(
			name: "AbolisherTests",
			dependencies: ["Library"],
			path: "Tests"
		),
	]
)
