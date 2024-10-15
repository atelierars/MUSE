//
//  vU256+.swift
//
//
//  Created by kotan.kn on 9/3/R6.
//
import Accelerate.vecLib.vBigNum
#if os(macOS)
extension vU256: @retroactive Hashable {
	@inlinable @inline(__always)
	public func hash(into hasher: inout Hasher) {
		withUnsafeBytes(of: self) {
			hasher.combine(bytes: $0)
		}
	}
}
extension vU256: @retroactive Comparable {
	@inlinable @inline(__always)
	public static func<(lhs: Self, rhs: Self) -> Bool {
		lhs.v.1 < rhs.v.1 ||
		lhs.v.0 < rhs.v.0
	}
	@inlinable @inline(__always)
	public static func>(lhs: Self, rhs: Self) -> Bool {
		lhs.v.1 > rhs.v.1 ||
		lhs.v.0 > rhs.v.0
	}
}
extension vU256 {
	@inlinable @inline(__always)
	public static func&=(lhs: inout Self, rhs: Self) {
		lhs.v.1 &= rhs.v.1
		lhs.v.0 &= rhs.v.0
	}
	@inlinable @inline(__always)
	public static func|=(lhs: inout Self, rhs: Self) {
		lhs.v.1 |= rhs.v.1
		lhs.v.0 |= rhs.v.0
	}
	@inlinable @inline(__always)
	public static func^=(lhs: inout Self, rhs: Self) {
		lhs.v.1 ^= rhs.v.1
		lhs.v.0 ^= rhs.v.0
	}
	@inlinable @inline(__always)
	public static prefix func~(x: Self) -> Self {
		.init(v: (~x.v.0, ~x.v.1))
	}
}
extension vU256: @retroactive UnsignedInteger, UnsignedBigInt {}
public typealias UInt256 = vU256
#endif
