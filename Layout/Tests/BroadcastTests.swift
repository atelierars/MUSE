//
//  BroadcastTests.swift
//  MUSE
//
//  Created by Kota on 8/21/R6.
//
import Testing
@testable import Layout
struct BroadcastTests {
	@Test func shape() {
		let x = [1,2,1]
		let y = [1,4]
		let z = broadcast(lhs: x, rhs: y)
		#expect(z == [2, 4])
	}
	@Test func stride() {
		let target = [5, 4, 3]
		let source = [4, 1]
		let stride = [1, 4]
		let result = broadcast(target: target, source: source, stride: stride)
		print(result)
	}
	@Test func capacity() {
		let shape = [1,3,5,2]
		let stride = [1,4,32]
		print(Layout.capacity(alloc: shape, stride: stride))
		print(Layout.capacity(slice: shape, stride: stride))
	}
}
