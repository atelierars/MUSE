//
//  Protocol+String.swift
//
//
//  Created by kotan.kn on 8/16/R6.
//
import RegexBuilder
import protocol LaTeX.CustomLaTeXStringConvertible
extension ComplexNumber {
	@inlinable
	@inline(__always)
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
	@inlinable
	@inline(__always)
	public var description: String {
		switch (real, imag) {
		case (0, 0):
			"0"
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
		switch (real, imag) {
		case (0, 0):
			"0"
		case (let r, 0):
			"\(r.latexDescription)"
		case (0, let i):
			"\(i.latexDescription)j"
		case let (r, i) where i < 0:
			"\(r.latexDescription)\(i.latexDescription)j"
		case let (r, i):
			"\(r.latexDescription)+\(i.latexDescription)j"
		}
	}
}
