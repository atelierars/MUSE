//
//  vUInt32+.swift
//
//
//  Created by kotan.kn on 9/3/R6.
//
import Accelerate.vecLib.vBigNum
extension vUInt32 {
	@inlinable @inline(__always) // internal use
	static func<(lhs: Self, rhs: Self) -> Bool {
		lhs.w < rhs.w ||
		lhs.z < rhs.z ||
		lhs.y < rhs.y ||
		lhs.x < rhs.x
	}
	@inlinable @inline(__always) // internal use
	static func>(lhs: Self, rhs: Self) -> Bool {
		lhs.w > rhs.w ||
		lhs.z > rhs.z ||
		lhs.y > rhs.y ||
		lhs.x > rhs.x
	}
}
