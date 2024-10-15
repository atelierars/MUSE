//
//  Protocol+BinaryFloatingPoint+.swift
//	RationalNumbers
//
//  Created by kotan.kn on 8/16/R6.
//
import func Darwin.modf
import func Darwin.fma
import Real_

// Stern–Brocot tree
func bs2<R: BinaryFloatingPoint>(r: R) -> (Int, Int) {
	let (s, u) = modf(r)
	let v = -u.magnitude
	guard v.isNormal else { return (Int(s), 1) }
	var (a, b) = (1,  0)
	var (c, d) = (0,  1)
	repeat {
		let p = b + d
		let q = a + c
		let t = R(q * q).ulp + .ulpOfOne
		switch fma(v, R(q), R(p)) {
		case ( t)...:
			c += a
			d += b
		case ...(-t):
			a += c
			b += d
		default:
			switch u.sign {
			case.plus:
				return (Int(s) * q + p, q)
			case.minus:
				return (Int(s) * q - p, q)
			}
		}
	} while true
}

extension BinaryFloatingPoint {
	@inlinable
	public init(_ value: some RationalNumber) {
		self = Self(value.numerator) / Self(value.denominator)
	}
}
extension RationalNumber {
	@inline(__always) // farey sequence
	@inlinable
	public init<Real: BinaryFloatingPoint>(_ χ: Real, error ε: Real = Real.ulpOfOne.squareRoot(), limit N: IntegerLiteralType = 1 << ( Real.significandBitCount / 2 )) {
		let (i, f) = switch modf(χ) {
		case ((let i, let f)) where f.isLess(than: .zero):
			(i - 1, f + 1)
		case let χ:
			χ
		}
		let p = sequence(state: ((0, 1), (1, 0)) as ((IntegerLiteralType, IntegerLiteralType), (IntegerLiteralType, IntegerLiteralType))) { state in
			switch state.0.1 + state.1.1 < N ? f * Real(state.0.1 + state.1.1) - Real(state.0.0 + state.1.0) : 0 {
			case ( ε)...:
				state.0.0 += state.1.0
				state.0.1 += state.1.1
				return.some(state)
			case ...(-ε):
				state.1.0 += state.0.0
				state.1.1 += state.0.1
				return.some(state)
			default: // nan, inf, et al
				return.none
			}
		}.suffix(1).last ?? ((0, 0), (0, 0)) as ((IntegerLiteralType, IntegerLiteralType), (IntegerLiteralType, IntegerLiteralType))
		let (numerator, denominator) = switch p {
		case((let a, let b), (let c, let d)) where b + d <= N:
			(a + c + .init(i) * ( b + d ), b + d)
		case(let q, (let c, let d)) where q.1 < d:
			(c + .init(i) * d, d)
		case((let a, let b), let q) where q.1 < b:
			(a + .init(i) * b, b)
		case((let a, let b), (let c, let d)):
			(( a + c + .init(i) * ( b + d ) ) / 2, ( b + d ) / 2)
		}
		self.init(numerator: numerator, denominator: denominator)
	}
}
extension RationalNumber where IntegerLiteralType: SignedInteger {
	/* 
	 NOTE: IEEE754 numbers are at least finite termed continued fractions.
	 it is of course unclear whether the bitwidth is sufficient
	 Use farey method (above one) or manually specify termination to expand continued fraction
	 like SomeRational.init(continuedFraction: FLP_VALUE.continuedFractionSequence().prefix(LIMIT))
	 */
	@inline(__always)
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
