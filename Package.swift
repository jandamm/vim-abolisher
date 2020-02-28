// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Abolisher",
    products: [
        .executable(name: "abolisher", targets: ["Abolisher"]),
    ],
    targets: [
        .target(name: "Abolisher", path: "Sources"),
        .testTarget(name: "AbolisherTests", dependencies: ["Abolisher"], path: "Tests"),
    ]
)
