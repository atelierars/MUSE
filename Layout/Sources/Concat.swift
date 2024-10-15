//
//  Concat.swift
//  Layout
//
//  Created by kotan.kn on 8/21/R6.
//
@inlinable @inline(__always)
public func concat<Element>(_ head: some Sequence<Element>, _ tail: some Sequence<Element>) -> some Sequence<Element> {
	sequence(state: (head.makeIterator(), tail.makeIterator())) {
		$0.0.next() ?? $0.1.next()
	}
}
@inlinable @inline(__always)
public func concat<Element>(_ head: some Sequence<Element>, _ tail: some Sequence<Element>, _ rest: some Sequence<Element>) -> some Sequence<Element> {
	sequence(state: (head.makeIterator(), tail.makeIterator(), rest.makeIterator())) {
		$0.0.next() ?? $0.1.next() ?? $0.2.next()
	}
}
@inlinable @inline(__always)
public func concat<Element>(_ list: some Sequence<some Sequence<Element>>) -> some Sequence<Element> {
	list.lazy.flatMap { $0 }
}
@inlinable @inline(__always)
public func concat<Element>(_ list: some Sequence<some Sequence<some Sequence<Element>>>) -> some Sequence<Element> {
	list.lazy.flatMap { $0.lazy.flatMap { $0 } }
}
extension Sequence where Element: Sequence {
	@inlinable @inline(__always)
	public var merge: some Sequence<Element.Element> {
		lazy.flatMap { $0 }
	}
}
extension Sequence where Element: Sequence, Element.Element: Sequence {
	@inlinable @inline(__always)
	public var merge: some Sequence<Element.Element.Element> {
		lazy.flatMap { $0.lazy.flatMap { $0 } }
	}
}
