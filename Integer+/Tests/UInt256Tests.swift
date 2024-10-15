//
//  UInt256Tests.swift
//	Integer+
//
//  Created by kotan.kn on 9/3/R6.
//
import Testing
@testable import Integer_
#if os(macOS)
private typealias Seed = UInt
private typealias Type = UInt256
@Suite
struct UInt256Tests {
	@Test
	func add() {
		let a = Seed.random(in: 0...1024)
		let b = Seed.random(in: 0...1024)
		let x = Type(integerLiteral: a)
		let y = Type(integerLiteral: b)
		#expect(x + y == Type(integerLiteral: a + b))
	}
	@Test
	func sub() {
		let a = Seed.random(in: 1024...2048)
		let b = Seed.random(in: 0...1024)
		let x = Type(integerLiteral: a)
		let y = Type(integerLiteral: b)
		#expect(x - y == Type(integerLiteral: a - b))
	}
	@Test
	func mul() {
		let a = Seed.random(in: 0...1024)
		let b = Seed.random(in: 0...1024)
		let x = Type(integerLiteral: a)
		let y = Type(integerLiteral: b)
		#expect(x * y == Type(integerLiteral: a * b))
	}
	@Test
	func div() {
		let a = Seed.random(in: 0...1024)
		let b = Seed.random(in: 1...1024)
		let x = Type(integerLiteral: a)
		let y = Type(integerLiteral: b)
		#expect(x / y == Type(integerLiteral: a / b))
	}
	@Test
	func EQ() {
		let x = 1024 as Type
		let y = 1024 as Type
		#expect(x == y)
	}
	@Test
	func GT() {
		let x = 1025 as Type
		let y = 1024 as Type
		#expect(x > y)
	}
	@Test
	func LT() {
		let x = 1023 as Type
		let y = 1024 as Type
		#expect(x < y)
	}
	@Test
	func testTrailing() {
		let x = 65536 as Type
		let y = x * x * x * x
		#expect(y.trailingZeroBitCount == 65536.trailingZeroBitCount * 4)
	}
}
#endif
