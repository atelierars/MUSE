// swift-tools-version: 6.0
import PackageDescription
let package = Package(
    name: "MUSE",
	platforms: [
		.iOS(.v18),
		.tvOS(.v18),
		.macOS(.v15),
		.macCatalyst(.v18)
	],
    products: [
    ],
    targets: [
//		.target(
//			name: "MSG",
//			dependencies: ["Dense", "ComplexNumbers"],
//			path: "MSG/Sources"
//		),
//		.target(
//			name: "MPS",
//			dependencies: ["Dense", "ComplexNumbers"],
//			path: "MPS/Sources"
//		),
//		.target(
//			name: "ALT",
//			dependencies: ["Dense", "ComplexNumbers"],
//			path: "ALT/Sources"
//		),
//		.target(
//			name: "LinearAlgebra",
//			dependencies: ["Dense", "Sparse"],
//			path: "LinearAlgebra/Sources",
//			cSettings: [
//				.define("ACCELERATE_NEW_LAPACK"),
//				.define("ACCELERATE_LAPACK_ILP64")
//			]
//		),
//		.target(
//			name: "Sparse",
//			dependencies: ["Dense"],
//			path: "Sparse/Sources",
//			cSettings: [
//				.define("ACCELERATE_NEW_LAPACK"),
//				.define("ACCELERATE_LAPACK_ILP64")
//			]
//		),
		.target(
			name: "Dense",
			dependencies: ["LaTeX", "Layout", "ComplexNumbers"],
			path: "Dense/Sources",
			cSettings: [
				.define("ACCELERATE_NEW_LAPACK"),
				.define("ACCELERATE_LAPACK_ILP64")
			]
		),
		.target(
			name: "Layout",
			dependencies: ["Integer+"],
			path: "Layout/Sources"
		),
		.target(
			name: "ComplexNumbers",
			dependencies: [.target(name: "LaTeX"), .target(name: "Real+")],
			path: "ComplexNumbers/Sources"
//			cSettings: [
//				.define("ACCELERATE_NEW_LAPACK"),
//				.define("ACCELERATE_LAPACK_ILP64")
//			]
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
			path: "Integer+/Sources",
			cSettings: [
				.define("ACCELERATE_NEW_LAPACK"),
				.define("ACCELERATE_LAPACK_ILP64")
			]
		),
		.target(
			name: "Real+",
			path: "Real+/Sources"
		),
//		.testTarget(
//			name: "MPSTests",
//			dependencies: [.target(name: "MPS")],
//			path: "MPS/Tests"
//		),
//		.testTarget(
//			name: "ALTTests",
//			dependencies: [.target(name: "ALT")],
//			path: "ALT/Tests"
//		),
//		.testTarget(
//			name: "LinearAlgebraTests",
//			dependencies: [.target(name: "LinearAlgebra")],
//			path: "LinearAlgebra/Tests",
//			cSettings: [
//				.define("ACCELERATE_NEW_LAPACK"),
//				.define("ACCELERATE_LAPACK_ILP64")
//			]
//		),
//		.testTarget(
//			name: "SparseTests",
//			dependencies: [.target(name: "Sparse")],
//			path: "Sparse/Tests",
//			cSettings: [
//				.define("ACCELERATE_NEW_LAPACK"),
//				.define("ACCELERATE_LAPACK_ILP64")
//			]
//		),
		.testTarget(
			name: "DenseTests",
			dependencies: [.target(name: "Dense")],
			path: "Dense/Tests",
			cSettings: [
				.define("ACCELERATE_NEW_LAPACK"),
				.define("ACCELERATE_LAPACK_ILP64")
			]
		),
		.testTarget(
			name: "LayoutTests",
			dependencies: [.target(name: "Layout")],
			path: "Layout/Tests"
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
