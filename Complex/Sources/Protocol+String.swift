//
//  Protocol+String.swift
//
//
//  Created by Kota on 8/16/R6.
//
import RegexBuilder
import protocol LaTeX.CustomLaTeXStringConvertible
extension ComplexNumber {
	@inline(__always)
	@inlinable
	public var description: String {
		switch (real, imag) {
		case (let r, 0):
			"\(r)"
		case let (r, i) where i < .zero:
			"\(r)\(i)j"
		case let (r, i):
			"\(r)+\(i)j"
		}
	}
}
extension ComplexNumber where FloatLiteralType: BinaryFloatingPoint {
	@inline(__always)
	@inlinable
	public var description: String {
		switch (real, imag) {
		case (let r, 0):
			"\(r)"
		case (let r, _) where r.isNaN:
			"NaN"
		case (_, let i) where i.isNaN:
			"NaN"
		case let (r, i) where i < .zero:
			"\(r)-\(i.magnitude)j"
		case let (r, i):
			"\(r)+\(i)j"
		}
	}
}
extension ComplexNumber where FloatLiteralType: CustomLaTeXStringConvertible {
	public var latexDescription: String {
		""
	}
}
