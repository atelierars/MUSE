//
//  Real+Tests.swift
//  Real+
//
//  Created by kotan.kn on 8/16/R6.
//
import Testing
import Real_
@Test
func continuedFractionExpansion() {
	let x = 2.0.squareRoot()
	let s = x.continuedFractionSequence(as: Int.self)
	#expect(Array(s.prefix(12)) == [1] + Array(repeating: 2, count: 11))
}
