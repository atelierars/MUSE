//
//  Protocol+String.swift
//
//
//  Created by kotan.kn on 8/16/R6.
//
import RegexBuilder
import LaTeX
extension RationalNumberProtocol {
	@inline(__always)
	@inlinable
	public var description: String {
		switch factor {
		case (0, 0):
			"NaN"
		case (0..., 0):
			"+Inf"
		case (...0, 0):
			"-Inf"
		case (let n,  1):
			"\(n)"
		case (let n, -1):
			"\(~n + 1)"
		case let (n, d):
			"\(n)/\(d)"
		}
	}
}
extension RationalNumberProtocol where IntegerLiteralType: FixedWidthInteger {
	@inline(__always)
	@inlinable
	public init?(_ string: String) {
		let parser = Regex {
			Anchor.startOfLine
			ZeroOrMore {
				.whitespace
			}
			Capture {
				Optionally {
					"-"
				}
				OneOrMore {
					.digit
				}
			} transform: { IntegerLiteralType($0, radix: 10) }
			Optionally {
				ZeroOrMore {
					.whitespace
				}
				"/"
				ZeroOrMore {
					.whitespace
				}
				Capture {
					Optionally {
						"-"
					}
					OneOrMore {
						.digit
					}
				}
			}
			Anchor.endOfLine
		}
		guard let match = string.firstMatch(of: parser), let numerator = match.output.1 else { return nil }
		self.init(numerator: numerator, denominator: match.output.2.flatMap { .init($0) } ?? 1)
	}
}
extension RationalNumberProtocol where IntegerLiteralType: CustomLaTeXStringConvertible {
	public var latexDescription: String {
		"\\frac{\(numerator.latexDescription)}{\(denominator.latexDescription)}"
	}
}
