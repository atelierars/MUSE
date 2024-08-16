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
			name: "MUSE",
			targets: [
				"RationalNumbers",
				"ComplexNumbers",
			]
		),
		.library(
			name: "RationalNumbers",
			targets: ["RationalNumbers"]
		),
		.library(
			name: "ComplexNumbers",
			targets: ["ComplexNumbers"]
		),
    ],
    targets: [
		.target(
			name: "ComplexNumbers",
			dependencies: [.target(name: "LaTeX"), .target(name: "Real+")],
			path: "ComplexNumbers/Sources"
		),
		.target(
			name: "RationalNumbers",
			dependencies: [.target(name: "LaTeX"), .target(name: "Real+"), .target(name: "Integer+")],
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
			name: "Integer+",
			path: "Integer+/Sources"
		),
		.target(
			name: "Real+",
			path: "Real+/Sources"
		),
		.testTarget(
			name: "Integer+Tests",
			dependencies: [.target(name: "Integer+")],
			path: "Integer+/Tests"
		),
		.testTarget(
			name: "Real+Tests",
			dependencies: [.target(name: "Real+")],
			path: "Real+/Tests"
		),
		.target(
			name: "LaTeX",
			path: "LaTeX/Sources"
		)
    ]
)
