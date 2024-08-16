//
//  Primitives.swift
//  
//
//  Created by kotan.kn on 8/16/R6.
//
import protocol LaTeX.CustomLaTeXStringConvertible
import Real_
@_exported import func Integer_.gcd
@_exported import func Integer_.lcm
public struct Rational<IntegerLiteralType: BinaryInteger & _ExpressibleByBuiltinIntegerLiteral> where IntegerLiteralType.Magnitude: BinaryInteger & _ExpressibleByBuiltinIntegerLiteral {
	public var numerator: IntegerLiteralType
	public var denominator: IntegerLiteralType
	public init(numerator n: IntegerLiteralType, denominator d: IntegerLiteralType) {
		(numerator, denominator) = (n, d)
	}
}
extension Rational: RationalNumber {
	public typealias Magnitude = Rational<IntegerLiteralType.Magnitude>
	@inline(__always)
	@inlinable
	public var magnitude: Magnitude {
		.init(numerator: numerator.magnitude, denominator: denominator.magnitude)
	}
}
extension Rational: CustomLaTeXStringConvertible where IntegerLiteralType: CustomLaTeXStringConvertible {}
extension Rational: ExpressibleByFloatLiteral where IntegerLiteralType: SignedInteger {}
public typealias Rational16 = Rational<Int8>
public typealias Rational32 = Rational<Int16>
public typealias Rational64 = Rational<Int32>
public typealias Rational128 = Rational<Int64>
