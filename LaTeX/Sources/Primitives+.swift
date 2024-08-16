//
//  Primitives.swift
//  
//
//  Created by kotan.kn on 8/16/R6.
//
import struct Foundation.Decimal
import class Foundation.NSNumber
extension BinaryInteger {
	public var latexDescription: String {
		String(describing: self)
	}
}
extension BinaryFloatingPoint {
	public var latexDescription: String {
		String(describing: self)
	}
}
extension Int8: CustomLaTeXStringConvertible {}
extension Int16: CustomLaTeXStringConvertible {}
extension Int32: CustomLaTeXStringConvertible {}
extension Int64: CustomLaTeXStringConvertible {}
extension UInt8: CustomLaTeXStringConvertible {}
extension UInt16: CustomLaTeXStringConvertible {}
extension UInt32: CustomLaTeXStringConvertible {}
extension UInt64: CustomLaTeXStringConvertible {}
extension Float16: CustomLaTeXStringConvertible {}
extension Float32: CustomLaTeXStringConvertible {}
extension Float64: CustomLaTeXStringConvertible {}
extension Decimal: CustomLaTeXStringConvertible {
	public var latexDescription: String {
		description
	}
}
extension NSNumber: CustomLaTeXStringConvertible {
	public var latexDescription: String {
		description
	}
}
