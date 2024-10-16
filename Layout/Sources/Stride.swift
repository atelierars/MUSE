//
//  Stride.swift
//  Layout
//
//  Created by Kota on 8/21/R6.
//
//@_disfavoredOverload
//@inline(__always)
//public func stride<S: Collection>(for shape: S, with stride: some Sequence<Int>) -> Array<Int> where S.Element == Int, S.Index == Int {
//	.init(unsafeUninitializedCapacity: shape.count) {
//		$0.initialize(repeating: 1)
//		let order = stride.enumerated().sorted { $0.element < $1.element }.map { $0.offset }
//		for (i, j) in order.enumerated().dropFirst() {
//			let k = order[i - 1]
//			$0[j] = $0[k] * shape[k]
//		}
//		$1 = $0.count
//	}
//}
//@inlinable
//@inline(__always)
//public func stride<T: BinaryInteger>(rowMajor shape: some Sequence<T>) -> Array<T> {
//	shape.dropLast().reduce(into: [1]) {
//		$0.append(($0.last ?? 0) * $1)
//	}
//}
//@inlinable
//@inline(__always)
//public func stride<T: BinaryInteger>(colMajor shape: some Sequence<T>) -> Array<T> {
//	stride(rowMajor: shape.reversed()).reversed()
//}
@inlinable
@inline(__always)
public func stride<T: BinaryInteger>(last shape: some Sequence<T>) -> Array<T> {
	stride(first: shape.reversed()).reversed()
}
@inlinable
@inline(__always)
public func stride<T: BinaryInteger>(first shape: some Sequence<T>) -> Array<T> {
	Array(sequence(state: (1 as T, shape.makeIterator())) { state in
		switch state.1.next() {
		case.some(let value):
			defer {
				state.0 *= value
			}
			return state.0
		case.none:
			return.none
		}
	})
}
@inlinable @inline(__always)
public func stride<S: FixedWidthInteger>(from start: SIMD2<S>, to end: SIMD2<S>, by step: SIMD2<S>) -> some Sequence<SIMD2<S>> {
	sequence(first: start) {
		all($0 .< end) ? .some($0 &+ step) : .none
	}
}
@inlinable @inline(__always)
public func stride<S: FixedWidthInteger>(from start: SIMD3<S>, to end: SIMD3<S>, by step: SIMD3<S>) -> some Sequence<SIMD3<S>> {
	sequence(first: start) {
		all($0 .< end) ? .some($0 &+ step) : .none
	}
}
@inlinable @inline(__always)
public func stride<S: FixedWidthInteger>(from start: SIMD4<S>, to end: SIMD4<S>, by step: SIMD4<S>) -> some Sequence<SIMD4<S>> {
	sequence(first: start) {
		all($0 .< end) ? .some($0 &+ step) : .none
	}
}
