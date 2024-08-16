//
//  RationalTests.swift
//
//
//  Created by kotan.kn on 8/16/R6.
//
import XCTest
@testable import RationalNumbers
final class RationalTests: XCTestCase {
	func testEQ() {
		XCTAssertEqual(Rational(numerator: 1, denominator: 2), Rational(numerator: 4, denominator: 8))
		XCTAssertEqual(Rational(numerator: 9, denominator: 0), Rational(numerator: 1, denominator: 0), "should be same, as infinites")
		XCTAssertNotEqual(Rational(numerator: 9, denominator: 0), Rational(numerator: -9, denominator: 0), "should be not same, positive and negative")
		XCTAssertNotEqual(Rational(numerator: 0, denominator: 0), Rational(numerator: 0, denominator: 0), "nan never match")
	}
	func testGT() {
		XCTAssertFalse(Rational(numerator: 3, denominator: 8) > Rational(numerator: 1, denominator: 2))
		XCTAssertTrue(Rational(numerator: 3, denominator: 2) > Rational(numerator: 1, denominator: 2))
		XCTAssertTrue(Rational(numerator: 3, denominator: 2) >= Rational(numerator: 1, denominator: 2))
		XCTAssertGreaterThan(Rational(numerator:  1, denominator: 0), Rational(numerator: .max, denominator: 1))
	}
	func testLT() {
		XCTAssertFalse(Rational(numerator: 1, denominator: 2) < Rational(numerator: 1, denominator: 3))
		XCTAssertTrue(Rational(numerator: 1, denominator: 2) < Rational(numerator: 3, denominator: 2))
		XCTAssertTrue(Rational(numerator: 1, denominator: 2) <= Rational(numerator: 3, denominator: 2))
		XCTAssertLessThan(Rational(numerator: -1, denominator: 0), Rational(numerator: .min, denominator: 1))
	}
	func testAdd() {
		let x = Rational<Int>(Float32.random(in: -3...3))
		let y = Rational<Int>(Float32.random(in: -3...3))
		XCTAssertTrue(x.isNormal)
		XCTAssertTrue(y.isNormal)
		XCTAssertEqual(Float64(x + y), Float64(x) + Float64(y), accuracy: 1e-5)
	}
	func testSub() {
		let x = Rational<Int>(Float32.random(in: -3...3))
		let y = Rational<Int>(Float32.random(in: -3...3))
		XCTAssertTrue(x.isNormal)
		XCTAssertTrue(y.isNormal)
		XCTAssertEqual(Float64(x - y), Float64(x) - Float64(y), accuracy: 1e-5)
	}
	func testMul() {
		let x = Rational<Int>(Float32.random(in: -3...3))
		let y = Rational<Int>(Float32.random(in: -3...3))
		XCTAssertTrue(x.isNormal)
		XCTAssertTrue(y.isNormal)
		XCTAssertEqual(Float64(x * y), Float64(x) * Float64(y), accuracy: 1e-5)
	}
	func testDiv() {
		let x = Rational<Int>(Float32.random(in: -1...1))
		let y = Rational<Int>(Float32.random(in: 1...10))
		XCTAssertTrue(x.isNormal)
		XCTAssertTrue(y.isNormal)
		XCTAssertEqual(Float64(x / y), Float64(x) / Float64(y), accuracy: 1e-5)
	}
	func testMod() {
		let x = Rational<Int>(Float32.random(in: -1...1))
		let y = Rational<Int>(Float32.random(in: 1...10))
		XCTAssertEqual(Float64(x % y), fmod(Float64(x), Float64(y)), accuracy: 1e-5)
		
		XCTAssertEqual(Rational<Int>(3, 1) % Rational<Int>(numerator: 1, denominator: 0), .init(numerator: 3, denominator: 1), "should be lhs")
		XCTAssertEqual(Rational<Int>(3, 1) % Rational<Int>(numerator: 0, denominator: 1), 0, "should be zer0")
		XCTAssertTrue((Rational<Int>(3, 1) % Rational<Int>(numerator: 0, denominator: 0)).factor == (0, 0), "should be nan")
	}
	func testContinuedFractionSqrt2() {
		let x = (2.0).squareRoot()
		let s = x.continuedFractionSequence(as: Int.self)
		XCTAssertEqual(Array(s.prefix(12)), [1] + Array(repeating: 2, count: 11))
	}
	func testContinuedFractionπ() {
		let q = Rational<Int>(continuedFraction: [3, 7, 15, 1, 292])
		XCTAssertEqual(.pi, Float64(q), accuracy: 1e-6)
	}
	func testFromBinaryFloatingPoint() {
		let x = 355.0 / 113.0
		let y = Rational<Int>(x)
		XCTAssertEqual(y, .init(numerator: 355, denominator: 113))
		XCTAssertEqual(.init(numerator: 977, denominator: 997), Rational<Int>(977.0/997.0))
	}
	func testFromContinuedFraction() {
		let x = 355.0 / 113.0
		let y = Rational<Int>(continuedFraction: x.continuedFractionSequence())
		XCTAssertEqual(y, .init(numerator: 355, denominator: 113))
		XCTAssertEqual(.init(numerator: 977, denominator: 997), Rational<Int>(continuedFraction: (977.0/997.0).continuedFractionSequence()))
	}
	func testFromContinuedFractionBinary() {
		let x = (1...).lazy.map{(2 * $0 - 1, $0 * $0)}
		let π = Rational(continuedFraction: x.prefix(12))
		XCTAssertEqual(.pi, 4 / Float64(π), accuracy: 1e-6)
	}
	func testRound() {
		for n in -31...31 {
			let x = Rational(numerator: n, denominator: 19)
			XCTAssertEqual(Float64(x.rounding(denominator: 4, toward: .positive)), (Float64(x)*4).rounded(.up)/4, accuracy: 1e-5)
			XCTAssertEqual(Float64(x.rounding(denominator: 4, toward: .negative)), (Float64(x)*4).rounded(.down)/4, accuracy: 1e-5)
			XCTAssertEqual(Float64(x.rounding(denominator: 4, toward: .zero)), (Float64(x)*4).rounded(.towardZero)/4, accuracy: 1e-5)
			XCTAssertEqual(Float64(x.rounding(denominator: 4, toward: .infinite)), (Float64(x)*4).rounded(.awayFromZero)/4, accuracy: 1e-5)
		}
	}
}
