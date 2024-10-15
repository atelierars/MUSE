//
//  BinaryIntegers+Tests.swift
//  
//
//  Created by kotan.kn on 8/16/R6.
//
import Testing
import Integer_
@Test
func prime() {
	#expect(Array(Int.Prime.prefix(11)) == [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31])
}
@Test
func fibonacci() {
	#expect(Array(Int.Fibonacci.prefix(11)) == [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55])
}
