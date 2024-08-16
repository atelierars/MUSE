//
//  Protocol`.swift
//  
//
//  Created by kotan.kn on 8/16/R6.
//
public protocol RationalNumberProtocol<IntegerLiteralType>: Numeric & Comparable & CustomStringConvertible & Hashable where IntegerLiteralType: BinaryInteger {
	var numerator: IntegerLiteralType { get }
	var denominator: IntegerLiteralType { get }
	init(numerator: IntegerLiteralType, denominator: IntegerLiteralType)
}
// Basics
extension RationalNumberProtocol {
	@inline(__always)
	@inlinable
	public init?<T>(exactly source: T) where T : BinaryInteger {
		guard let value = IntegerLiteralType(exactly: source) else { return nil }
		self.init(numerator: value, denominator: 1)
	}
	@inline(__always)
	@inlinable
	public init(integerLiteral value: IntegerLiteralType) {
		self.init(numerator: value, denominator: 1)
	}
	@inline(__always)
	@inlinable
	public init(_ numerator: IntegerLiteralType, _ denominator: IntegerLiteralType = 1) {
		self.init(numerator: numerator, denominator: denominator)
	}
}
// Foundations
extension RationalNumberProtocol {
	@inline(__always)
	@inlinable
	public var inverse: Self {
		.init(numerator: denominator, denominator: numerator)
	}
}
extension RationalNumberProtocol {
	@inline(__always)
	@inlinable
	var factor: (IntegerLiteralType, IntegerLiteralType) {
		denominator == .zero ?
			(numerator, denominator) :
			(numerator / abs(gcd(numerator, denominator)), denominator / abs(gcd(numerator, denominator)))
	}
	@inline(__always)
	@inlinable
	static func comparison(lhs: Self, rhs: Self, comparator: (IntegerLiteralType, IntegerLiteralType) -> Bool) -> Bool {
		switch (lhs.factor, rhs.factor) {
		case ((0, 0), (0, 0)), ((0, 0), _), (_, (0, 0)): // NaN comparison
			return false
		case ((let ln, 0), (let rn, 0)): // Infinites
			return comparator(ln.signum(), rn.signum())
		case let ((ln, ld), (rn, rd)):
			let n = gcd(ln, rd)
			let d = gcd(rn, ld)
			return comparator(div(ln, n) * div(rd, n) * n, div(rn, d) * div(ld, d) * d)
		}
	}
}
// Equatable
extension RationalNumberProtocol {
	@inline(__always)
	@inlinable
	public static func==(lhs: Self, rhs: Self) -> Bool {
		comparison(lhs: lhs, rhs: rhs, comparator: ==)
	}
}
// Comparable
extension RationalNumberProtocol {
	@inline(__always)
	@inlinable
	public static func<(lhs: Self, rhs: Self) -> Bool {
		comparison(lhs: lhs, rhs: rhs, comparator: <)
	}
	@inline(__always)
	@inlinable
	public static func>(lhs: Self, rhs: Self) -> Bool {
		comparison(lhs: lhs, rhs: rhs, comparator: >)
	}
	@inline(__always)
	@inlinable
	public static func<=(lhs: Self, rhs: Self) -> Bool {
		comparison(lhs: lhs, rhs: rhs, comparator: <=)
	}
	@inline(__always)
	@inlinable
	public static func>=(lhs: Self, rhs: Self) -> Bool {
		comparison(lhs: lhs, rhs: rhs, comparator: >=)
	}
}
extension RationalNumberProtocol {
	@inlinable
	public var isInfinite: Bool {
		denominator == .zero && numerator != .zero
	}
	@inlinable
	public var isNaN: Bool {
		denominator == .zero && numerator == .zero
	}
	@inlinable
	public var isFinite: Bool {
		denominator != .zero
	}
	@inlinable
	public var isNormal: Bool {
		denominator != .zero && numerator != .zero
	}
	@inlinable
	public var isZero: Bool {
		denominator != .zero && numerator == .zero
	}
}
