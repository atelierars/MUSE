//
//  Protocol+SIMD.swift
//
//
//  Created by kotan.kn on 8/16/R6.
//
import simd
extension ComplexNumber where FloatLiteralType: SIMDScalar & BinaryFloatingPoint {
	public static func+(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self) + unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self), to: Self.self)
	}
	public static func-(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(unsafeBitCast(lhs, to: SIMD2<FloatLiteralType>.self) - unsafeBitCast(rhs, to: SIMD2<FloatLiteralType>.self), to: Self.self)
	}
}
extension ComplexNumber where FloatLiteralType == Float32 {
	public init(r: FloatLiteralType, θ: FloatLiteralType) {
		self = unsafeBitCast(r * unsafeBitCast(__sincosf_stret(θ), to: SIMD2<FloatLiteralType>.self), to: Self.self)
	}
	public static func*(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(SIMD2(lhs.real, lhs.imag), SIMD2(rhs.real, -rhs.imag)),
			dot(SIMD2(lhs.real, lhs.imag), SIMD2(rhs.imag,  rhs.real))
		), to: Self.self)
	}
	public static func/(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(SIMD2(lhs.real, lhs.imag), SIMD2( rhs.real, rhs.imag)),
			dot(SIMD2(lhs.real, lhs.imag), SIMD2(-rhs.imag, rhs.real))
		) / rhs.magnitude, to: Self.self)
	}
	public var magnitude: FloatLiteralType {
		length_squared(unsafeBitCast(self, to: SIMD2<FloatLiteralType>.self))
	}
}
extension ComplexNumber where FloatLiteralType == Float64 {
	public init(r: FloatLiteralType, θ: FloatLiteralType) {
		self = unsafeBitCast(r * unsafeBitCast(__sincos_stret(θ), to: SIMD2<FloatLiteralType>.self), to: Self.self)
	}
	public static func*(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(SIMD2(lhs.real, lhs.imag), SIMD2(rhs.real, -rhs.imag)),
			dot(SIMD2(lhs.real, lhs.imag), SIMD2(rhs.imag,  rhs.real))
		), to: Self.self)
	}
	public static func/(lhs: Self, rhs: Self) -> Self {
		unsafeBitCast(SIMD2(
			dot(SIMD2(lhs.real, lhs.imag), SIMD2( rhs.real, rhs.imag)),
			dot(SIMD2(lhs.real, lhs.imag), SIMD2(-rhs.imag, rhs.real))
		) / rhs.magnitude, to: Self.self)
	}
	public var magnitude: FloatLiteralType {
		length_squared(unsafeBitCast(self, to: SIMD2<FloatLiteralType>.self))
	}
}
