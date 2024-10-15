//
//  vS1024+.swift
//
//
//  Created by kotan.kn on 9/3/R6.
//
import Accelerate.vecLib.vBigNum
#if os(macOS)
extension vS1024 {
	public typealias Magnitude = vU1024
	public var magnitude: Magnitude {
		unsafeBitCast(v.7.w < 0x8000_0000 ? self : -self, to: Magnitude.self)
	}
	public func signum() -> Self {
		v.7.w < 0x8000_0000 ? self == .zero ? 0 : 1 : -1
	}
}
extension vS1024: @retroactive Hashable {
	@inlinable @inline(__always)
	public func hash(into hasher: inout Hasher) {
		withUnsafeBytes(of: self) {
			hasher.combine(bytes: $0)
		}
	}
}
extension vS1024: @retroactive Comparable {
	@inlinable @inline(__always)
	public static func<(lhs: Self, rhs: Self) -> Bool {
		var lhs = lhs
		var rhs = rhs
		lhs.v.7.w ^= 0x8000_0000
		rhs.v.7.w ^= 0x8000_0000
		return
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
		var lhs = lhs
		var rhs = rhs
		lhs.v.7.w ^= 0x8000_0000
		rhs.v.7.w ^= 0x8000_0000
		return
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
extension vS1024 {
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
extension vS1024: @retroactive SignedInteger, SignedBigInt {}
public typealias Int1024 = vS1024
#endif
