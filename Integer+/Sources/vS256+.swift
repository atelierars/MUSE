//
//  vS256+.swift
//
//
//  Created by kotan.kn on 9/3/R6.
//
import Accelerate.vecLib.vBigNum
#if os(macOS)
extension vS256 {
	public typealias Magnitude = vU256
	public var magnitude: Magnitude {
		unsafeBitCast(v.1.w < 0x8000_0000 ? self : -self, to: Magnitude.self)
	}
	public func signum() -> Self {
		v.1.w < 0x8000_0000 ? self == .zero ? 0 : 1 : -1
	}
}
extension vS256: @retroactive Hashable {
	@inlinable @inline(__always)
	public func hash(into hasher: inout Hasher) {
		withUnsafeBytes(of: self) {
			hasher.combine(bytes: $0)
		}
	}
}
extension vS256: @retroactive Comparable {
	@inlinable @inline(__always)
	public static func<(lhs: Self, rhs: Self) -> Bool {
		var lhs = lhs
		var rhs = rhs
		lhs.v.1.w ^= 0x8000_0000
		rhs.v.1.w ^= 0x8000_0000
		return
			lhs.v.1 < rhs.v.1 ||
			lhs.v.0 < rhs.v.0
	}
	@inlinable @inline(__always)
	public static func>(lhs: Self, rhs: Self) -> Bool {
		var lhs = lhs
		var rhs = rhs
		lhs.v.1.w ^= 0x8000_0000
		rhs.v.1.w ^= 0x8000_0000
		return
			lhs.v.1 > rhs.v.1 ||
			lhs.v.0 > rhs.v.0
	}
}
extension vS256 {
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
extension vS256: @retroactive SignedInteger, SignedBigInt {}
public typealias Int256 = vS256
#endif
