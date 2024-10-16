//
//  Protocol.swift
//	LaTeX
//
//  Created by kotan.kn on 8/16/R6.
//
public protocol CustomLaTeXStringConvertible: CustomStringConvertible {
	var latexDescription: String { get }
}
