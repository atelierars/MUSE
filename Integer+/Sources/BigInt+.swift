//
//  BigInt+.swift
//
//
//  Created by kotan.kn on 9/3/R6.
//
import Accelerate.vecLib.vBigNum
import Darwin
enum BigIntRadix: UInt8 {
	case bin = 2
	case oct = 8
	case dec = 10
	case hex = 16
}
extension BigIntRadix {
	var prefix: String {
		switch self {
		case.bin:
			"0b"
		case.oct:
			"0o"
		case.dec:
			""
		case.hex:
			"0x"
		}
	}
}
protocol BigInt: BinaryInteger where Words == Array<UInt> {
	@inlinable @inline(__always)
	static func neg(source: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>)
	@inlinable @inline(__always)
	static func sat(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>)
	@inlinable @inline(__always)
	static func add(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>)
	@inlinable @inline(__always)
	static func sub(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>)
	@inlinable @inline(__always)
	static func mul(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>)
	@inlinable @inline(__always)
	static func div(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>, remainder: UnsafeMutablePointer<Self>)
	@inlinable @inline(__always)
	static func mod(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>)
	@inlinable @inline(__always)
	static func lshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>)
	@inlinable @inline(__always)
	static func rshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>)
	@inlinable @inline(__always)
	init()
}
extension BigInt {
	@inlinable @inline(__always)
	public var words: Words {
		withUnsafeBytes(of: self) {
			Array($0.assumingMemoryBound(to: Words.Element.self))
		}
	}
}
extension BigInt {
	@inlinable @inline(__always)
	public static func+(lhs: Self, rhs: Self) -> Self {
		var lhs = lhs
		var rhs = rhs
		var ret = Self()
		add(lhs: &lhs, rhs: &rhs, result: &ret)
		return ret
	}
	@inlinable @inline(__always)
	public static func-(lhs: Self, rhs: Self) -> Self {
		var lhs = lhs
		var rhs = rhs
		var ret = Self()
		sub(lhs: &lhs, rhs: &rhs, result: &ret)
		return ret
	}
	@inlinable @inline(__always)
	public static func*(lhs: Self, rhs: Self) -> Self {
		var lhs = lhs
		var rhs = rhs
		var ret = Self()
		mul(lhs: &lhs, rhs: &rhs, result: &ret)
		return ret
	}
	@inlinable @inline(__always)
	public static func/(lhs: Self, rhs: Self) -> Self {
		var lhs = lhs
		var rhs = rhs
		var ret = Self()
		var rem = Self()
		div(lhs: &lhs, rhs: &rhs, result: &ret, remainder: &rem)
		return ret
	}
	@inlinable @inline(__always)
	public static func%(lhs: Self, rhs: Self) -> Self {
		var lhs = lhs
		var rhs = rhs
		var ret = Self()
		mod(lhs: &lhs, rhs: &rhs, result: &ret)
		return ret
	}
}
extension BigInt {
	@inlinable @inline(__always)
	public static func+=(lhs: inout Self, rhs: Self) {
		var ref = lhs
		var rhs = rhs
		add(lhs: &ref, rhs: &rhs, result: &lhs)
	}
	@inlinable @inline(__always)
	public static func-=(lhs: inout Self, rhs: Self) {
		var ref = lhs
		var rhs = rhs
		sub(lhs: &ref, rhs: &rhs, result: &lhs)
	}
	@inlinable @inline(__always)
	public static func*=(lhs: inout Self, rhs: Self) {
		var ref = lhs
		var rhs = rhs
		mul(lhs: &ref, rhs: &rhs, result: &lhs)
	}
	@inlinable @inline(__always)
	public static func/=(lhs: inout Self, rhs: Self) {
		var ref = lhs
		var rhs = rhs
		var rem = Self()
		div(lhs: &ref, rhs: &rhs, result: &lhs, remainder: &rem)
	}
	@inlinable @inline(__always)
	public static func%=(lhs: inout Self, rhs: Self) {
		var ref = lhs
		var rhs = rhs
		mod(lhs: &ref, rhs: &rhs, result: &lhs)
	}
}
extension BigInt {
	@inlinable @inline(__always)
	public static func<<=<RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
		var ref = lhs
		lshift(source: &ref, amount: .init(truncatingIfNeeded: rhs), result: &lhs)
	}
	@inlinable @inline(__always)
	public static func>>=<RHS>(lhs: inout Self, rhs: RHS) where RHS : BinaryInteger {
		var ref = lhs
		rshift(source: &ref, amount: .init(truncatingIfNeeded: rhs), result: &lhs)
	}
}
extension BigInt {
	@inlinable @inline(__always)
	public var bitWidth: Int {
		MemoryLayout<Self>.size * 8
	}
	@inlinable @inline(__always)
	public var trailingZeroBitCount: Int {
		withUnsafeBytes(of: self) {
			let memory = $0.assumingMemoryBound(to: UInt32.self)
			let offset = memory.prefix { $0.trailingZeroBitCount == 32 }.count
			return offset * 32 + ( memory.dropFirst(offset).first.map { $0.trailingZeroBitCount } ?? 0 )
		}
	}
	@inlinable @inline(__always)
	public func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self) {
		withUnsafeTemporaryAllocation(of: Self.self, capacity: 4) {
			let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0)
			let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1)
			let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2)
			let w = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3)
			x.pointee = self
			y.pointee = rhs
			Self.div(lhs: x, rhs: y, result: z, remainder: w)
			return (z.pointee, w.pointee)
		}
	}
}
#if os(macOS)
extension vU256: BigInt {
	@inline(__always)
	public static let zero: Self = .init()
	@inlinable @inline(__always)
	public static func==(lhs: Self, rhs: Self) -> Bool {
		lhs.v.1 == rhs.v.1 &&
		lhs.v.0 == rhs.v.0
	}
	@inlinable @inline(__always)
	static func neg(source: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU256Neg(source, result)
	}
	@inlinable @inline(__always)
	static func sat(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU256AddS(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func add(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU256Add(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func sub(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU256Sub(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func mul(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU256HalfMultiply(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func div(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>, remainder: UnsafeMutablePointer<Self>) {
		vU256Divide(lhs, rhs, result, remainder)
	}
	@inlinable @inline(__always)
	static func mod(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU256Mod(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func lshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>) {
		vLL256Shift(source, amount, result)
	}
	@inlinable @inline(__always)
	static func rshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>) {
		vLR256Shift(source, amount, result)
	}
}
extension vS256: BigInt {
	@inline(__always)
	public static let zero: Self = .init()
	@inlinable @inline(__always)
	public static func==(lhs: Self, rhs: Self) -> Bool {
		lhs.v.1 == rhs.v.1 &&
		lhs.v.0 == rhs.v.0
	}
	@inlinable @inline(__always)
	static func neg(source: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS256Neg(source, result)
	}
	@inlinable @inline(__always)
	static func sat(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS256AddS(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func add(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS256Add(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func sub(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS256Sub(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func mul(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS256HalfMultiply(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func div(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>, remainder: UnsafeMutablePointer<Self>) {
		vS256Divide(lhs, rhs, result, remainder)
	}
	@inlinable @inline(__always)
	static func mod(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS256Mod(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func lshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>) {
		source.withMemoryRebound(to: vU256.self, capacity: 1) { s in
			result.withMemoryRebound(to: vU256.self, capacity: 1) { t in
				vLL256Shift(s, amount, t)
			}
		}
	}
	@inlinable @inline(__always)
	static func rshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>) {
		vA256Shift(source, amount, result)
	}
}
extension vU512: BigInt {
	@inline(__always)
	public static let zero: Self = .init()
	@inlinable @inline(__always)
	public static func==(lhs: Self, rhs: Self) -> Bool {
		lhs.v.3 == rhs.v.3 &&
		lhs.v.2 == rhs.v.2 &&
		lhs.v.1 == rhs.v.1 &&
		lhs.v.0 == rhs.v.0
	}
	@inlinable @inline(__always)
	static func neg(source: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU512Neg(source, result)
	}
	@inlinable @inline(__always)
	static func sat(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU512AddS(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func add(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU512Add(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func sub(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU512Sub(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func mul(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU512HalfMultiply(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func div(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>, remainder: UnsafeMutablePointer<Self>) {
		vU512Divide(lhs, rhs, result, remainder)
	}
	@inlinable @inline(__always)
	static func mod(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU512Mod(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func lshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>) {
		vLL512Shift(source, amount, result)
	}
	@inlinable @inline(__always)
	static func rshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>) {
		vLR512Shift(source, amount, result)
	}
}
extension vS512: BigInt {
	@inline(__always)
	public static let zero: Self = .init()
	@inlinable @inline(__always)
	public static func==(lhs: Self, rhs: Self) -> Bool {
		lhs.v.3 == rhs.v.3 &&
		lhs.v.2 == rhs.v.2 &&
		lhs.v.1 == rhs.v.1 &&
		lhs.v.0 == rhs.v.0
	}
	@inlinable @inline(__always)
	static func neg(source: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS512Neg(source, result)
	}
	@inlinable @inline(__always)
	static func sat(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS512AddS(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func add(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS512Add(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func sub(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS512Sub(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func mul(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS512HalfMultiply(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func div(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>, remainder: UnsafeMutablePointer<Self>) {
		vS512Divide(lhs, rhs, result, remainder)
	}
	@inlinable @inline(__always)
	static func mod(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS512Mod(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func lshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>) {
		source.withMemoryRebound(to: vU512.self, capacity: 1) { s in
			result.withMemoryRebound(to: vU512.self, capacity: 1) { t in
				vLL512Shift(s, amount, t)
			}
		}
	}
	@inlinable @inline(__always)
	static func rshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>) {
		vA512Shift(source, amount, result)
	}
}
extension vU1024: BigInt {
	@inline(__always)
	public static let zero: Self = .init()
	@inlinable @inline(__always)
	public static func==(lhs: Self, rhs: Self) -> Bool {
		lhs.v.7 == rhs.v.7 &&
		lhs.v.6 == rhs.v.6 &&
		lhs.v.5 == rhs.v.5 &&
		lhs.v.4 == rhs.v.4 &&
		lhs.v.3 == rhs.v.3 &&
		lhs.v.2 == rhs.v.2 &&
		lhs.v.1 == rhs.v.1 &&
		lhs.v.0 == rhs.v.0
	}
	@inlinable @inline(__always)
	static func neg(source: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU1024Neg(source, result)
	}
	@inlinable @inline(__always)
	static func sat(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU1024AddS(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func add(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU1024Add(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func sub(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU1024Sub(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func mul(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU1024HalfMultiply(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func div(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>, remainder: UnsafeMutablePointer<Self>) {
		vU1024Divide(lhs, rhs, result, remainder)
	}
	@inlinable @inline(__always)
	static func mod(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vU1024Mod(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func lshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>) {
		vLL1024Shift(source, amount, result)
	}
	@inlinable @inline(__always)
	static func rshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>) {
		vLR1024Shift(source, amount, result)
	}
}
extension vS1024: BigInt {
	@inline(__always)
	public static let zero: Self = .init()
	@inlinable @inline(__always)
	public static func==(lhs: Self, rhs: Self) -> Bool {
		lhs.v.7 == rhs.v.7 &&
		lhs.v.6 == rhs.v.6 &&
		lhs.v.5 == rhs.v.5 &&
		lhs.v.4 == rhs.v.4 &&
		lhs.v.3 == rhs.v.3 &&
		lhs.v.2 == rhs.v.2 &&
		lhs.v.1 == rhs.v.1 &&
		lhs.v.0 == rhs.v.0
	}
	@inlinable @inline(__always)
	static func neg(source: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS1024Neg(source, result)
	}
	@inlinable @inline(__always)
	static func sat(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS1024AddS(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func add(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS1024Add(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func sub(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS1024Sub(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func mul(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS1024HalfMultiply(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func div(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>, remainder: UnsafeMutablePointer<Self>) {
		vS1024Divide(lhs, rhs, result, remainder)
	}
	@inlinable @inline(__always)
	static func mod(lhs: UnsafePointer<Self>, rhs: UnsafePointer<Self>, result: UnsafeMutablePointer<Self>) {
		vS1024Mod(lhs, rhs, result)
	}
	@inlinable @inline(__always)
	static func lshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>) {
		source.withMemoryRebound(to: vU1024.self, capacity: 1) { s in
			result.withMemoryRebound(to: vU1024.self, capacity: 1) { t in
				vLL1024Shift(s, amount, t)
			}
		}
	}
	@inlinable @inline(__always)
	static func rshift(source: UnsafePointer<Self>, amount: UInt32, result: UnsafeMutablePointer<Self>) {
		vA1024Shift(source, amount, result)
	}
}
protocol UnsignedBigInt: BigInt & UnsignedInteger & CustomStringConvertible & Strideable {
	@inlinable @inline(__always)
	init(integerLiteral value: UInt)
}
extension UnsignedBigInt {
	@inlinable @inline(__always)
	public init<T>(clamping source: T) where T : BinaryInteger {
		func dcm(_ source: T) -> Self {
			switch source.quotientAndRemainder(dividingBy: 2) {
			case (0, let r):
				return.init(integerLiteral: .init(truncatingIfNeeded: r))
			case (let q, let r):
				var a = dcm(q)
				var b = Self(integerLiteral: .init(truncatingIfNeeded: r))
				var c = Self()
				Self.sat(lhs: &a, rhs: &a, result: &c)
				Self.sat(lhs: &c, rhs: &b, result: &a)
				return a
			}
		}
		self = dcm(source)
	}
	@inlinable @inline(__always)
	public init<T>(truncatingIfNeeded source: T) where T : BinaryInteger {
		func dcm(_ source: T) -> Self {
			switch source.quotientAndRemainder(dividingBy: 2) {
			case (0, let r):
				return.init(integerLiteral: .init(truncatingIfNeeded: r))
			case (let q, let r):
				var a = dcm(q)
				var b = Self(integerLiteral: .init(truncatingIfNeeded: r))
				var c = Self()
				Self.add(lhs: &a, rhs: &a, result: &c)
				Self.add(lhs: &c, rhs: &b, result: &a)
				return a
			}
		}
		self = dcm(source)
	}
	@inlinable @inline(__always)
	public init<T>(_ source: T) where T : BinaryInteger {
		self.init(truncatingIfNeeded: source)
	}
	@inlinable @inline(__always)
	public init?<T>(exactly source: T) where T : BinaryInteger {
		func dcm(_ source: T) -> Optional<Self> {
			switch source.quotientAndRemainder(dividingBy: 2) {
			case (0, let r):
				.init(integerLiteral: .init(truncatingIfNeeded: r))
			case (let q, let r):
				dcm(q).flatMap { a in
					var r = Self(integerLiteral: .init(truncatingIfNeeded: r))
					var b = a
					var t = Self()
					Self.add(lhs: &b, rhs: &b, result: &t)
					Self.add(lhs: &t, rhs: &r, result: &b)
					return a.magnitude < b.magnitude ? .some(b) : .none
				}
			}
		}
		switch dcm(source) {
		case.some(let value):
			self = value
		case.none:
			return nil
		}
	}
	@inlinable @inline(__always)
	public init<T>(_ source: T) where T : BinaryFloatingPoint {
		func dcm(_ source: T) -> Self {
			let r = source.truncatingRemainder(dividingBy: 2)
			let q = ( source - r ) / 2
			var p = Self(integerLiteral: .init(r))
			if q.magnitude < 1 {
				return p
			} else {
				var a = dcm(q)
				var t = Self()
				Self.add(lhs: &a, rhs: &a, result: &t)
				Self.add(lhs: &t, rhs: &p, result: &a)
				return a
			}
		}
		self = dcm(source)
	}
	@inlinable @inline(__always)
	public init?<T>(exactly source: T) where T : BinaryFloatingPoint {
		func dcm(_ source: T) -> Optional<Self> {
			let r = source.remainder(dividingBy: 2)
			let q = ( source - r ) / 2
			var p = Self(integerLiteral: .init(r))
			if q.magnitude < 1 {
				return p
			} else if q.isNormal, let a = dcm(q) {
				var b = a
				var t = Self()
				Self.add(lhs: &b, rhs: &b, result: &t)
				Self.add(lhs: &t, rhs: &p, result: &b)
				return a.magnitude < b.magnitude ? .some(b) : .none
			} else {
				return.none
			}
		}
		switch dcm(source) {
		case.some(let value):
			self = value
		case.none:
			return nil
		}
	}
}
extension UnsignedBigInt {
	@inlinable @inline(__always)
	public init(integerLiteral value: UInt) {
		self = withUnsafeTemporaryAllocation(of: Self.self, capacity: 1) {
			$0.withMemoryRebound(to: UInt32.self) { target in
				let length = withUnsafeBytes(of: value) {
					target.initialize(fromContentsOf: $0.assumingMemoryBound(to: UInt32.self))
				}
				target[length...].initialize(repeating: .zero)
			}
			return $0.first.unsafelyUnwrapped
		}
	}
	@inlinable @inline(__always)
	public var description: String {
		description(radix: .dec)
	}
	@inlinable @inline(__always)
	func description(radix: BigIntRadix) -> String {
		withUnsafeTemporaryAllocation(of: Self.self, capacity: 4) {
			let x = $0.baseAddress.unsafelyUnwrapped.advanced(by: 0)
			let y = $0.baseAddress.unsafelyUnwrapped.advanced(by: 1)
			let z = $0.baseAddress.unsafelyUnwrapped.advanced(by: 2)
			let w = $0.baseAddress.unsafelyUnwrapped.advanced(by: 3)
			x.pointee = self
			y.pointee = .init(integerLiteral: .init(radix.rawValue))
			var digits = Array<Character>()
			repeat {
				Self.div(lhs: x, rhs: y, result: z, remainder: w)
				switch w.pointee {
				case 0x0:digits.append("0")
				case 0x1:digits.append("1")
				case 0x2:digits.append("2")
				case 0x3:digits.append("3")
				case 0x4:digits.append("4")
				case 0x5:digits.append("5")
				case 0x6:digits.append("6")
				case 0x7:digits.append("7")
				case 0x8:digits.append("8")
				case 0x9:digits.append("9")
				case 0xa:digits.append("a")
				case 0xb:digits.append("b")
				case 0xc:digits.append("c")
				case 0xd:digits.append("d")
				case 0xe:digits.append("e")
				case 0xf:digits.append("f")
				default:assertionFailure()
				}
				x.pointee = z.pointee
			} while x.pointee != 0
			return radix.prefix + .init(digits.reversed())
		}
	}
}
protocol SignedBigInt: BigInt & SignedInteger & CustomStringConvertible & Strideable where Magnitude: UnsignedBigInt {
	@inlinable @inline(__always)
	init(integerLiteral value: Int)
}
extension SignedBigInt {
	@inlinable @inline(__always)
	public init<T>(clamping source: T) where T : BinaryInteger {
		func dcm(_ source: T) -> Self {
			switch source.quotientAndRemainder(dividingBy: 2) {
			case (0, let r):
				return.init(integerLiteral: .init(truncatingIfNeeded: r))
			case (let q, let r):
				var a = dcm(q)
				var b = Self(integerLiteral: .init(truncatingIfNeeded: r))
				var c = Self()
				Self.sat(lhs: &a, rhs: &a, result: &c)
				Self.sat(lhs: &c, rhs: &b, result: &a)
				return a
			}
		}
		self = dcm(source)
	}
	@inlinable @inline(__always)
	public init<T>(truncatingIfNeeded source: T) where T : BinaryInteger {
		func dcm(_ source: T) -> Self {
			switch source.quotientAndRemainder(dividingBy: 2) {
			case (0, let r):
				return Self(integerLiteral: .init(truncatingIfNeeded: r))
			case (let q, let r):
				var a = dcm(q)
				var b = Self(integerLiteral: .init(truncatingIfNeeded: r))
				var c = Self()
				Self.add(lhs: &a, rhs: &a, result: &c)
				Self.add(lhs: &c, rhs: &b, result: &a)
				return a
			}
		}
		self = dcm(source)
	}
	@inlinable @inline(__always)
	public init<T>(_ source: T) where T : BinaryInteger {
		self.init(truncatingIfNeeded: source)
	}
	@inlinable @inline(__always)
	public init?<T>(exactly source: T) where T : BinaryInteger {
		func dcm(_ source: T) -> Optional<Self> {
			switch source.quotientAndRemainder(dividingBy: 2) {
			case (0, let r):
				.some(.init(integerLiteral: .init(truncatingIfNeeded: r)))
			case (let q, let r):
				dcm(q).flatMap { a in
					var r = Self(integerLiteral: .init(truncatingIfNeeded: r))
					var b = a
					var t = Self()
					Self.add(lhs: &b, rhs: &b, result: &t)
					Self.add(lhs: &t, rhs: &r, result: &b)
					return a.magnitude < b.magnitude ? .some(b) : .none
				}
			}
		}
		switch dcm(source) {
		case.some(let value):
			self = value
		case.none:
			return nil
		}
	}
	@inlinable @inline(__always)
	public init<T>(_ source: T) where T : BinaryFloatingPoint {
		func dcm(_ source: T) -> Self {
			let r = source.remainder(dividingBy: 2)
			let q = ( source - r ) / 2
			var p = Self(integerLiteral: .init(r))
			if q.magnitude < 1 {
				return p
			} else {
				var a = dcm(q)
				var t = Self()
				Self.add(lhs: &a, rhs: &a, result: &t)
				Self.add(lhs: &t, rhs: &p, result: &a)
				return a
			}
		}
		self = dcm(source)
	}
	@inlinable @inline(__always)
	public init?<T>(exactly source: T) where T : BinaryFloatingPoint {
		func dcm(_ source: T) -> Optional<Self> {
			let r = source.remainder(dividingBy: 2)
			let q = ( source - r ) / 2
			if q.magnitude < 1 {
				return.some(.init(integerLiteral: .init(r)))
			} else if q.isNormal, let a = dcm(q) {
				var b = a
				var t = Self()
				var p = Self(integerLiteral: .init(r))
				Self.add(lhs: &b, rhs: &b, result: &t)
				Self.add(lhs: &t, rhs: &p, result: &b)
				return a.magnitude < b.magnitude ? .some(b) : .none
			} else {
				return.none
			}
		}
		switch dcm(source) {
		case.some(let value):
			self = value
		case.none:
			return nil
		}
	}
}
extension SignedBigInt {
	@inlinable @inline(__always)
	public init(integerLiteral value: Int) {
		self = withUnsafeTemporaryAllocation(of: Self.self, capacity: 1) {
			if value < 0 {
				$0.withMemoryRebound(to: UInt32.self) { target in
					let length = withUnsafeBytes(of: -value) {
						target.initialize(fromContentsOf: $0.assumingMemoryBound(to: UInt32.self))
					}
					target[length...].initialize(repeating: .zero)
				}
				return -$0.first.unsafelyUnwrapped
			} else {
				$0.withMemoryRebound(to: UInt32.self) { target in
					let length = withUnsafeBytes(of: value) {
						target.initialize(fromContentsOf: $0.assumingMemoryBound(to: UInt32.self))
					}
					target[length...].initialize(repeating: .zero)
				}
				return $0.first.unsafelyUnwrapped
			}
		}
	}
}
extension SignedBigInt {
	@inlinable @inline(__always)
	public static prefix func-(source: Self) -> Self {
		withUnsafePointer(to: source) {
			neg(source: $0, result: .init(mutating: $0))
			return $0.pointee
		}
	}
	@inlinable @inline(__always)
	public var description: String {
		( signum() < 0 ? "-" : "" ) + magnitude.description
	}
}
#endif
