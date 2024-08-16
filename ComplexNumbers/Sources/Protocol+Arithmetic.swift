//
//  Protocol+Arithmetic.swift
//  
//
//  Created by kotan.kn on 8/16/R6.
//
extension ComplexNumber {
	@inline(__always)
	@inlinable
	public static func+(lhs: Self, rhs: Self) -> Self {
		let real = lhs.real + rhs.real
		let imag = lhs.imag + rhs.imag
		return.init(real: real, imag: imag)
	}
	@inline(__always)
	@inlinable
	public static func-(lhs: Self, rhs: Self) -> Self {
		let real = lhs.real - rhs.real
		let imag = lhs.imag - rhs.imag
		return.init(real: real, imag: imag)
	}
	@inline(__always)
	@inlinable
	public static func*(lhs: Self, rhs: Self) -> Self {
		let real = lhs.real * rhs.real - lhs.imag * rhs.imag
		let imag = lhs.imag * rhs.real + lhs.real * rhs.imag
		return.init(real: real, imag: imag)
	}
}
extension ComplexNumber {
	@inline(__always)
	@inlinable
	public static func+=(lhs: inout Self, rhs: Self) {
		lhs = lhs + rhs
	}
	@inline(__always)
	@inlinable
	public static func-=(lhs: inout Self, rhs: Self) {
		lhs = lhs - rhs
	}
	@inline(__always)
	@inlinable
	public static func*=(lhs: inout Self, rhs: Self) {
		lhs = lhs * rhs
	}
}
extension ComplexNumber where FloatLiteralType: BinaryInteger {
	@inline(__always)
	@inlinable
	public static func/(lhs: Self, rhs: Self) -> Self {
		let norm = rhs.real * rhs.real + rhs.imag * rhs.imag
		let real = lhs.real * rhs.real + lhs.imag * rhs.imag
		let imag = lhs.real * rhs.imag - lhs.imag * rhs.real
		return.init(real: real / norm, imag: imag / norm)
	}
	@inline(__always)
	@inlinable
	public static func/=(lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}
}
extension ComplexNumber where FloatLiteralType: BinaryFloatingPoint {
	@inline(__always)
	@inlinable
	public static func/(lhs: Self, rhs: Self) -> Self {
		let norm = rhs.real * rhs.real + rhs.imag * rhs.imag
		let real = lhs.real * rhs.real + lhs.imag * rhs.imag
		let imag = lhs.real * rhs.imag - lhs.imag * rhs.real
		return.init(real: real / norm, imag: imag / norm)
	}
	@inline(__always)
	@inlinable
	public static func/=(lhs: inout Self, rhs: Self) {
		lhs = lhs / rhs
	}
}
extension ComplexNumber {
	@inline(__always)
	@inlinable
	public static prefix func-(_ χ: Self) -> Self {
		.init(real: -χ.real, imag: -χ.imag)
	}
}
extension ComplexNumber {
	@inline(__always)
	@inlinable
	public static func==(lhs: Self, rhs: Self) -> Bool {
		(lhs.real, lhs.imag) == (rhs.real, rhs.imag)
	}
}
