//
//  BinaryInteger+.swift
//
//
//  Created by kotan.kn on 8/16/R6.
//
@inline(__always)
@inlinable
public func div<Z: BinaryInteger>(_ x: Z, _ y: Z) -> Z { // private use, avoid aborting, suitable for NaN and Inf formats (_, 0)
	y == .zero ? .zero : ( x / y )
}
@inline(__always)
@inlinable
public func abs<T: BinaryInteger>(_ x: T) -> T { // obtain magnitude without any typecast
	x < 0 ? ~x + 1 : x
}
@inline(__always)
@inlinable
public func mod<T: BinaryInteger>(_ x: T, _ y: T) -> T { // proof. lim_{ε→∞}{\frac{a}{b} mod \frac{1}{ε}} = 0
	y == .zero ? .zero : ( x % y + y ) % y
}
@inline(__always)
@inlinable
public func gcd<T: BinaryInteger>(_ x: T, _ y: T) -> T {
	y == .zero ? x : gcd(y, x % y)
}
@inline(__always)
@inlinable
public func lcm<T: BinaryInteger>(_ x: T, _ y: T) -> T {
	switch gcd(x, y) {
	case 0: // i.e. lcm(0, 0)
		0
	case let z:
		( x / z ) * ( y / z ) * z // avoid overflow
	}
}
extension BinaryInteger {
	@inlinable
	public var squareRoot: Self {
		precondition(0 <= self)
		guard 1 < self else { return self }
		var x0 = self / 2
		var x1 = (x0 + self / x0) / 2
		while x1 < x0 {
			(x0, x1) = (x1, (x1 + self / x1) / 2)
		}
		return x0
	}
	@inlinable
	public static var Prime: some Sequence<Self> {
		sequence(state: Array<Self>()) { state in
			var value = state.last ?? 1
			let limit = value.squareRoot + 1
			let tests = state.prefix { $0 <= limit }
			repeat {
				value = value + 1
			} while !tests.allSatisfy { value % $0 != 0 }
			defer {
				state.append(value)
			}
			return.some(value)
		}
	}
	@inlinable
	public static var Fibonacci: some Sequence<Self> {
		sequence(state: ((0, 1) as (Self, Self))) { state in
			defer {
				state = (state.1, state.0 + state.1)
			}
			return state.0
		}
	}
}

