//
//  SpecialFunctions.swift
//  Real+
//
//  Created by kotan.kn on 8/16/R6.
//
import Darwin
public protocol SpecialFunctionScalar: ElementaryFunctionScalar {
	// Erf
	@inline(__always) @inlinable static func erf(_ χ: Self) -> Self
	@inline(__always) @inlinable static func erfc(_ χ: Self) -> Self
	// Gamma
	@inline(__always) @inlinable static func tgamma(_ χ: Self) -> Self
	@inline(__always) @inlinable static func lgamma(_ χ: Self) -> Self
}
extension Float32: SpecialFunctionScalar {
	@inline(__always) @inlinable public static func erf(_ χ: Self) -> Self { Darwin.erf(χ) }
	@inline(__always) @inlinable public static func erfc(_ χ: Self) -> Self { Darwin.erfc(χ) }
	@inline(__always) @inlinable public static func tgamma(_ χ: Self) -> Self { Darwin.tgamma(χ) }
	@inline(__always) @inlinable public static func lgamma(_ χ: Self) -> Self { Darwin.lgammaf(χ) }
}
extension Float64: SpecialFunctionScalar {
	@inline(__always) @inlinable public static func erf(_ χ: Self) -> Self { Darwin.erf(χ) }
	@inline(__always) @inlinable public static func erfc(_ χ: Self) -> Self { Darwin.erfc(χ) }
	@inline(__always) @inlinable public static func tgamma(_ χ: Self) -> Self { Darwin.tgamma(χ) }
	@inline(__always) @inlinable public static func lgamma(_ χ: Self) -> Self { Darwin.lgamma(χ) }
}
extension SpecialFunctionScalar where IntegerLiteralType: SignedInteger, IntegerLiteralType.Stride: SignedInteger {
	@inline(__always)
	@inlinable
	public static func bessel(j ν: Self, _ χ: Self) -> Self {
		var result = .zero as Self
//		guard .zero <= χ || .zero == fmod(ν, 1) else { return.nan }
//		let z = log(2) - log(fabs(χ))
		let z = 0.5 * χ
		for k in IntegerLiteralType.zero... {
			let m = Self(integerLiteral: k)
//			let l = fma(fma(2, m, ν), z, lgamma(m + 1) + lgamma(m + 1 + ν))
//			let v = exp(-l)
			let v = pow(z, fma(2, m, ν)) / tgamma(m + 1) / tgamma(m + 1 + ν)
			if !(result.ulp.magnitude <= v.magnitude) {
				break
			} else if k % 2 == .zero {
				result += v
			} else {
				result -= v
			}
		}
		return result
	}
}
