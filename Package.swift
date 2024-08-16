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
			targets: ["Rational"]
		),
		.library(
			name: "ComplexNumbers",
			targets: ["Complex"]
		),
    ],
    targets: [
		.target(
			name: "Complex",
			dependencies: [.target(name: "LaTeX")],
			path: "Complex/Sources"
		),
		.target(
			name: "Rational",
			dependencies: [.target(name: "LaTeX")],
			path: "Rational/Sources"
		),
		.testTarget(
			name: "ComplexTests",
			dependencies: [.target(name: "Complex")],
			path: "Complex/Tests"
		),
		.testTarget(
			name: "RationalTests",
			dependencies: [.target(name: "Rational")],
			path: "Rational/Tests"
		),
		.target(
			name: "Real",
			path: "Real/Sources"
		),
		.target(
			name: "LaTeX",
			path: "LaTeX/Sources"
		)
    ]
)
