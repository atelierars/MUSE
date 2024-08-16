//
//  Protocol+BinaryFloatingPoint+.swift
//
//
//  Created by kotan.kn on 8/16/R6.
//
import func Darwin.modf
extension BinaryFloatingPoint {
	@inlinable
	public init(_ value: some RationalNumberProtocol) {
		self = Self(value.numerator) / Self(value.denominator)
	}
}
extension RationalNumberProtocol {
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
