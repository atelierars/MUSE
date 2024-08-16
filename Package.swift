// swift-tools-version: 5.9
import PackageDescription
let package = Package(
    name: "MUSE",
	platforms: [
		.iOS(.v17),
		.tvOS(.v17),
		.macOS(.v14),
		.macCatalyst(.v17)
	],
    products: [
		.library(
			name: "RationalNumers",
			targets: ["RationalNumbers"]
		),
		.library(
			name: "ComplexNumbers",
			targets: ["ComplexNumbers"]
		),
        .library(
            name: "MUSE",
            targets: ["RationalNumbers", "ComplexNumbers"]),
    ],
    targets: [
		.target(
			name: "ComplexNumbers",
			dependencies: [.target(name: "LaTeX")],
			path: "ComplexNumbers/Sources"
		),
		.target(
			name: "RationalNumbers",
			dependencies: [.target(name: "LaTeX")],
			path: "RationalNumbers/Sources"
		),
		.testTarget(
			name: "ComplexNumbersTests",
			dependencies: [.target(name: "ComplexNumbers")],
			path: "ComplexNumbers/Tests"
		),
		.testTarget(
			name: "RationalNumbersTests",
			dependencies: [.target(name: "RationalNumbers")],
			path: "RationalNumbers/Tests"
		),
		.target(
			name: "LaTeX",
			path: "LaTeX/Sources"
		)
    ]
)
