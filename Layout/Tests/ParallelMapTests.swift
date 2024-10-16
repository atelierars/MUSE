//
//  ParallelMapTests.swift
//  MUSE
//
//  Created by Kota on 9/6/R6.
//
import Testing
import class Foundation.Thread
@testable import Layout
@Suite
struct ParallelMapTests {
	@Test(TimeLimitTrait.timeLimit(.minutes(1)))
	func sleepMap() {
		let x = Array<ClosedRange<Int>>(repeating: -12...12, count: 72).map(Int.random(in:))
		let y = x.map { $0 * $0 }
		let z = x.parallelMap { // without parallel execution, it takes 72 seconds which is over timeout
			Thread.sleep(forTimeInterval: 1)
			return $0 * $0
		}
		#expect(y == z)
	}
	@Test(TimeLimitTrait.timeLimit(.minutes(1)))
	func actor() async throws {
		actor A {
			init() {}
			func sleep(for timeout: Duration) async throws {
				try await Task.sleep(for: timeout)
			}
		}
		try await withThrowingDiscardingTaskGroup { group in
//			let executors = repeatElement((), count: 72).parallelMap(A.init)
			let executors = repeatElement((), count: 72).map(A.init)
			for executor in executors {
				group.addTask {
					try await executor.sleep(for: .seconds(1))
				}
			}
		}
	}
}
