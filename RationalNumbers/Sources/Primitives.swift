//
//  Primitives.swift
//  
//
//  Created by kotan.kn on 8/16/R6.
//
import protocol LaTeX.CustomLaTeXStringConvertible
public struct Rational<IntegerLiteralType: BinaryInteger & _ExpressibleByBuiltinIntegerLiteral> where IntegerLiteralType.Magnitude: BinaryInteger & _ExpressibleByBuiltinIntegerLiteral {
	public var numerator: IntegerLiteralType
	public var denominator: IntegerLiteralType
	public init(numerator: IntegerLiteralType, denominator: IntegerLiteralType) {
		self.numerator = numerator
		self.denominator = denominator
	}
}
extension Rational: RationalNumberProtocol {
	public typealias Magnitude = Rational<IntegerLiteralType.Magnitude>
	@inline(__always)
	@inlinable
	public var magnitude: Magnitude {
		.init(numerator: numerator.magnitude, denominator: denominator.magnitude)
	}
}
extension Rational: CustomLaTeXStringConvertible where IntegerLiteralType: CustomLaTeXStringConvertible {}
extension Rational: ExpressibleByFloatLiteral where IntegerLiteralType: SignedInteger {
	/* NOTE: IEEE754 numbers are at least finite termed continued fractions. it is of course unclear whether the bitwidth is sufficient */
	@inline(__always) //
	@inlinable
	public init(floatLiteral value: FloatLiteralType) {
		self = switch (value.sign, value.exponent) {
		case (.plus, 0...):
			Self(numerator: 1 << value.exponent, denominator: 1) * Self(continuedFraction: value.significand.continuedFractionSequence())
		case (.minus, 0...):
			Self(numerator: 1 << value.exponent, denominator: -1) * Self(continuedFraction: value.significand.continuedFractionSequence())
		case (.plus, ...0):
			Self(numerator: 1, denominator: 1 << -value.exponent) * Self(continuedFraction: value.significand.continuedFractionSequence())
		case (.minus, ...0):
			Self(numerator: -1, denominator: 1 << -value.exponent) * Self(continuedFraction: value.significand.continuedFractionSequence())
		default:
			Self(numerator: 0, denominator: 0)
		}
	}
}
public typealias Rational16 = Rational<Int8>
public typealias Rational32 = Rational<Int16>
public typealias Rational64 = Rational<Int32>
public typealias Rational128 = Rational<Int64>
