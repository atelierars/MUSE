//
//  Protocol.swift
//
//
//  Created by kotan.kn on 8/16/R6.
//
public protocol ComplexNumberProtocol<FloatLiteralType>: Numeric & Comparable & Hashable & CustomStringConvertible where IntegerLiteralType == FloatLiteralType.IntegerLiteralType, Magnitude == FloatLiteralType {
	associatedtype FloatLiteralType: SignedNumeric & Comparable & Hashable
	var real: FloatLiteralType { get set }
	var imag: FloatLiteralType { get set }
	init(real: FloatLiteralType, imag: FloatLiteralType)
	static var i: Self { get }
}
extension ComplexNumberProtocol {
	public static var i: Self {
		.init(real: 0, imag: 1)
	}
}
extension ComplexNumberProtocol {
	@inline(__always)
	@inlinable
	public var conjugate: Self {
		.init(real: real, imag: -imag)
	}
}
extension ComplexNumberProtocol {
	@inline(__always)
	@inlinable
	public init?<T>(exactly source: T) where T : BinaryInteger {
		guard let real = FloatLiteralType(exactly: source) else { return nil }
		self.init(real: real, imag: 0)
	}
	@inline(__always)
	@inlinable
	public init(integerLiteral value: FloatLiteralType.IntegerLiteralType) {
		self.init(real: .init(integerLiteral: value), imag: 0)
	}
	@inline(__always)
	@inlinable
	public init(floatLiteral value: FloatLiteralType) {
		self.init(real: value, imag: 0)
	}
}
extension ComplexNumberProtocol where FloatLiteralType: BinaryInteger {
	public init(_ other: some ComplexNumberProtocol<some BinaryFloatingPoint>) {
		self.init(real: .init(other.real), imag: .init(other.imag))
	}
}
extension ComplexNumberProtocol where FloatLiteralType: BinaryFloatingPoint {
	public init(_ other: some ComplexNumberProtocol<some BinaryInteger>) {
		self.init(real: .init(other.real), imag: .init(other.imag))
	}
}
extension ComplexNumberProtocol {
	public static func<(lhs: Self, rhs: Self) -> Bool {
		lhs.magnitude < rhs.magnitude
	}
	public static func>(lhs: Self, rhs: Self) -> Bool {
		lhs.magnitude > rhs.magnitude
	}
	public static func<=(lhs: Self, rhs: Self) -> Bool {
		lhs.magnitude <= rhs.magnitude
	}
	public static func>=(lhs: Self, rhs: Self) -> Bool {
		lhs.magnitude >= rhs.magnitude
	}
}
extension ComplexNumberProtocol {
	@inline(__always)
	@inlinable
	public var magnitude: Magnitude {
		real * real + imag * imag
	}
}
extension ComplexNumberProtocol {
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
extension ComplexNumberProtocol where FloatLiteralType: BinaryFloatingPoint {
	@inline(__always)
	@inlinable
	public var description: String {
		switch (real, imag) {
		case (let r, 0):
			"\(r)"
		case let (r, i) where i < .zero:
			"\(r)\(i)j"
		case (let r, _) where r.isNaN:
			"NaN"
		case (_, let i) where i.isNaN:
			"NaN"
		case let (r, i):
			"\(r)+\(i)j"
		}
	}
}
extension ComplexNumberProtocol where FloatLiteralType: ComplexNumberProtocol {
	public var simplified: FloatLiteralType {
		real + imag * .i
	}
}
