//
//  Axis.swift
//  MUSE
//
//  Created by Kota on 9/26/R6.
//
extension Int: @retroactive RangeExpression {
	@inlinable @inline(__always)
	public func relative<C>(to collection: C) -> Range<Int> where C : Collection, Int == C.Index {
		(self..<self).relative(to: collection)
	}
	@inlinable @inline(__always)
	public func contains(_ element: Int) -> Bool {
		self == element
	}
}
