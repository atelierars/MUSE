//
//  File.swift
//  
//
//  Created by kotan.kn on 8/16/R6.
//
import XCTest
@testable import Real_
final class BinaryFloatingPointTests: XCTestCase {
	func testContinuedFractionExpansion() {
		let x = 2.0.squareRoot()
		let s = x.continuedFractionSequence(as: Int.self)
		XCTAssertEqual(Array(s.prefix(12)), [1] + Array(repeating: 2, count: 11))
	}
}
