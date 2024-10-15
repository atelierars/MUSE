//
//  vU1024+.swift
//
//
//  Created by kotan.kn on 9/3/R6.
//
import Accelerate.vecLib.vBigNum
#if os(macOS)
extension vU1024: @retroactive Hashable {
	@inlinable @inline(__always)
	public func hash(into hasher: inout Hasher) {
		withUnsafeBytes(of: self) {
			hasher.combine(bytes: $0)
		}
	}
}
extension vU1024: @retroactive Comparable {
	@inlinable @inline(__always)
	public static func<(lhs: Self, rhs: Self) -> Bool {
		lhs.v.7 < rhs.v.7 ||
		lhs.v.6 < rhs.v.6 ||
		lhs.v.5 < rhs.v.5 ||
		lhs.v.4 < rhs.v.4 ||
		lhs.v.3 < rhs.v.3 ||
		lhs.v.2 < rhs.v.2 ||
		lhs.v.1 < rhs.v.1 ||
		lhs.v.0 < rhs.v.0
	}
	@inlinable @inline(__always)
	public static func>(lhs: Self, rhs: Self) -> Bool {
		lhs.v.7 > rhs.v.7 ||
		lhs.v.6 > rhs.v.6 ||
		lhs.v.5 > rhs.v.5 ||
		lhs.v.4 > rhs.v.4 ||
		lhs.v.3 > rhs.v.3 ||
		lhs.v.2 > rhs.v.2 ||
		lhs.v.1 > rhs.v.1 ||
		lhs.v.0 > rhs.v.0
	}
}
extension vU1024 {
	@inlinable @inline(__always)
	public static func&=(lhs: inout Self, rhs: Self) {
		lhs.v.7 &= rhs.v.7
		lhs.v.6 &= rhs.v.6
		lhs.v.5 &= rhs.v.5
		lhs.v.4 &= rhs.v.4
		lhs.v.3 &= rhs.v.3
		lhs.v.2 &= rhs.v.2
		lhs.v.1 &= rhs.v.1
		lhs.v.0 &= rhs.v.0
	}
	@inlinable @inline(__always)
	public static func|=(lhs: inout Self, rhs: Self) {
		lhs.v.7 |= rhs.v.7
		lhs.v.6 |= rhs.v.6
		lhs.v.5 |= rhs.v.5
		lhs.v.4 |= rhs.v.4
		lhs.v.3 |= rhs.v.3
		lhs.v.2 |= rhs.v.2
		lhs.v.1 |= rhs.v.1
		lhs.v.0 |= rhs.v.0
	}
	@inlinable @inline(__always)
	public static func^=(lhs: inout Self, rhs: Self) {
		lhs.v.7 ^= rhs.v.7
		lhs.v.6 ^= rhs.v.6
		lhs.v.5 ^= rhs.v.5
		lhs.v.4 ^= rhs.v.4
		lhs.v.3 ^= rhs.v.3
		lhs.v.2 ^= rhs.v.2
		lhs.v.1 ^= rhs.v.1
		lhs.v.0 ^= rhs.v.0
	}
	@inlinable @inline(__always)
	public static prefix func~(x: Self) -> Self {
		.init(v: (~x.v.0, ~x.v.1, ~x.v.2, ~x.v.3, ~x.v.4, ~x.v.5, ~x.v.6, ~x.v.7))
	}
}
extension vU1024: @retroactive UnsignedInteger, UnsignedBigInt {}
public typealias UInt1024 = vU1024
#endif
