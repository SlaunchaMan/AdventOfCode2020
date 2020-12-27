//
//  Puzzle.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/4/20.
//

import Foundation

public protocol Year {
    static var allPuzzles: [Puzzle.Type] { get }
    static var year: Int { get }
}

public let allYears: [Year.Type] = [
    Year2015.self,
    Year2016.self,
    Year2020.self
]

public protocol Puzzle {
    static var year: Year.Type { get }
    static var day: Int { get }
    static func part1() -> String
}

public protocol TwoPartPuzzle: Puzzle {
    static func part2() -> String
}

public protocol PuzzleWithExample1: Puzzle {
    static func example1() -> String
}

public protocol PuzzleWithExample2: TwoPartPuzzle {
    static func example2() -> String
}

public typealias TwoPartPuzzleWithExample1 = TwoPartPuzzle & PuzzleWithExample1
public typealias FullPuzzle = PuzzleWithExample1 & PuzzleWithExample2
