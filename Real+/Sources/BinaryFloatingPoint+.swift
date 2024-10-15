//
//  BinaryFloatingPoint+.swift
//  Real+
//
//  Created by kotan.kn on 8/16/R6.
//
import func Darwin.modf
extension BinaryFloatingPoint {
	public func continuedFractionSequence<T: BinaryInteger>(as type: T.Type = T.self, terminate: @escaping (Self) -> Bool = { $0.magnitude.isLessThanOrEqualTo(.ulpOfOne.squareRoot()) }) -> some Sequence<T> {
		sequence(state: self) {
			guard $0.isNormal else { return.none }
			let (v, a) = modf($0)
			$0 = terminate(a) ? 0 : 1 / a
			return.some(.init(v))
		}.prefix(Self.significandBitCount * 8)
	}
}
