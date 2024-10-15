//
//  vU512+.swift
//
//
//  Created by kotan.kn on 9/3/R6.
//
import Accelerate.vecLib.vBigNum
#if os(macOS)
extension vU512: @retroactive Hashable {
	@inlinable @inline(__always)
	public func hash(into hasher: inout Hasher) {
		withUnsafeBytes(of: self) {
			hasher.combine(bytes: $0)
		}
	}
}
extension vU512: @retroactive Comparable {
	@inlinable @inline(__always)
	public static func<(lhs: Self, rhs: Self) -> Bool {
		lhs.v.3 < rhs.v.3 ||
		lhs.v.2 < rhs.v.2 ||
		lhs.v.1 < rhs.v.1 ||
		lhs.v.0 < rhs.v.0
	}
	@inlinable @inline(__always)
	public static func>(lhs: Self, rhs: Self) -> Bool {
		lhs.v.3 > rhs.v.3 ||
		lhs.v.2 > rhs.v.2 ||
		lhs.v.1 > rhs.v.1 ||
		lhs.v.0 > rhs.v.0
	}
}
extension vU512 {
	@inlinable @inline(__always)
	public static func&=(lhs: inout Self, rhs: Self) {
		lhs.v.3 &= rhs.v.3
		lhs.v.2 &= rhs.v.2
		lhs.v.1 &= rhs.v.1
		lhs.v.0 &= rhs.v.0
	}
	@inlinable @inline(__always)
	public static func|=(lhs: inout Self, rhs: Self) {
		lhs.v.3 |= rhs.v.3
		lhs.v.2 |= rhs.v.2
		lhs.v.1 |= rhs.v.1
		lhs.v.0 |= rhs.v.0
	}
	@inlinable
	public static func^=(lhs: inout Self, rhs: Self) {
		lhs.v.3 ^= rhs.v.3
		lhs.v.2 ^= rhs.v.2
		lhs.v.1 ^= rhs.v.1
		lhs.v.0 ^= rhs.v.0
	}
	@inlinable @inline(__always)
	public static prefix func~(x: Self) -> Self {
		.init(v: (~x.v.0, ~x.v.1, ~x.v.2, ~x.v.3))
	}
}
extension vU512: @retroactive UnsignedInteger, UnsignedBigInt {}
public typealias UInt512 = vU512
#endif
