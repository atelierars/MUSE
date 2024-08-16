//
//  BinaryIntegers+Tests.swift
//  
//
//  Created by kotan.kn on 8/16/R6.
//
import XCTest
@testable import RationalNumbers
final class BinaryIntegerTests: XCTestCase {
	func testPrime() {
		let primes = Int.Prime.prefix(11)
		XCTAssertEqual(Array(primes), [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31])
	}
	func testFibonacci() {
		let primes = Int.Fibonacci.prefix(11)
		XCTAssertEqual(Array(primes), [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55])
	}
}
