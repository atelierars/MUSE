//
//  Strategy.swift
//	Layout
//
//  Created by kotan.kn on 9/1/R6.
//
@_exported import enum Accelerate.AccelerateMatrixOrder
public typealias MemoryStrategy = AccelerateMatrixOrder
extension MemoryStrategy {
	@inlinable
	public var transpose: Self {
		switch self {
		case.rowMajor:
			.columnMajor
		case.columnMajor:
			.rowMajor
		}
	}
}
extension MemoryStrategy {
	public func stride(for shape: some BidirectionalCollection<Int>) -> Array<Int> {
		switch self {
		case.columnMajor:
			.init(sequence(state: (1, shape.makeIterator())) { state in
				state.1.next().map { value in
					defer {
						state.0 *= value
					}
					return state.0
				}
			})
		case.rowMajor:
			sequence(state: (1, shape.reversed().makeIterator())) { state in
				state.1.next().map { value in
					defer {
						state.0 *= value
					}
					return state.0
				}
			}.reversed()
		}
	}
}
//public enum Strategy {
//	case first
//	case last
//}
//extension Strategy {
//	@inlinable
//	public var transpose: Self {
//		switch self {
//		case.first:
//			.last
//		case.last:
//			.first
//		}
//	}
//}
//extension Strategy {
//	public func stride(for shape: some BidirectionalCollection<Int>) -> Array<Int> {
//		switch self {
//		case.first:
//			Array(sequence(state: (1, shape.makeIterator())) { state in
//				state.1.next().map { value in
//					defer {
//						state.0 *= value
//					}
//					return state.0
//				}
//			})
//		case.last:
//			sequence(state: (1, shape.reversed().makeIterator())) { state in
//				state.1.next().map { value in
//					defer {
//						state.0 *= value
//					}
//					return state.0
//				}
//			}.reversed()
//		}
//	}
//}
