//
//  Primitives.swift
//
//
//  Created by Kota on 8/16/R6.
//
import Accelerate
import LaTeX
public struct Complex<FloatLiteralType: BinaryFloatingPoint & _ExpressibleByBuiltinFloatLiteral>: Numeric & Comparable & CustomStringConvertible & Hashable {
	public var real: FloatLiteralType
	public var imag: FloatLiteralType
	public init(real: FloatLiteralType, imag: FloatLiteralType) {
		self.real = real
		self.imag = imag
	}
}
extension Complex: ComplexNumber {
	public typealias Magnitude = FloatLiteralType
}
extension Complex: CustomLaTeXStringConvertible where FloatLiteralType: CustomLaTeXStringConvertible {}
public typealias Complex32 = Complex<Float16>
public typealias Complex64 = Complex<Float32>
public typealias Complex128 = Complex<Float64>
extension DSPComplex: ComplexNumber {
	public typealias Magnitude = Float32
	public func hash(into hasher: inout Hasher) {
		real.hash(into: &hasher)
		imag.hash(into: &hasher)
	}
}
extension DSPDoubleComplex: ComplexNumber {
	public typealias Magnitude = Float64
	public func hash(into hasher: inout Hasher) {
		real.hash(into: &hasher)
		imag.hash(into: &hasher)
	}
}
extension __CLPK_complex: ComplexNumber {
	public typealias Magnitude = __CLPK_real
	public var real: __CLPK_real { r }
	public var imag: __CLPK_real { i }
	public init(real: __CLPK_real, imag: __CLPK_real) {
		self.init(r: real, i: imag)
	}
	public func hash(into hasher: inout Hasher) {
		r.hash(into: &hasher)
		i.hash(into: &hasher)
	}
}
extension __CLPK_doublecomplex: ComplexNumber {
	public typealias Magnitude = __CLPK_doublereal
	public var real: __CLPK_doublereal { r }
	public var imag: __CLPK_doublereal { i }
	public init(real: __CLPK_doublereal, imag: __CLPK_doublereal) {
		self.init(r: real, i: imag)
	}
	public func hash(into hasher: inout Hasher) {
		r.hash(into: &hasher)
		i.hash(into: &hasher)
	}
}
