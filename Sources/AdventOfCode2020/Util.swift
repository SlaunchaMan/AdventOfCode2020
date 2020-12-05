//
//  Util.swift
//  AdventOfCode2020
//
//  Created by Jeff Kelley on 12/4/20.
//

import Foundation

public protocol Puzzle {
    static var day: Int { get }
    static func part1() -> String
    static func part2() -> String
}

public protocol PuzzleWithExample1: Puzzle {
    static func example1() -> String
}

public protocol PuzzleWithExample2: Puzzle {
    static func example2() -> String
}

public typealias FullPuzzle = PuzzleWithExample1 & PuzzleWithExample2

public let AllPuzzles: [Puzzle.Type] = [
    Day1.self,
    Day2.self,
    Day3.self,
    Day4.self
]

extension Puzzle {
    
    static func log(_ message: @autoclosure() -> Any) {
        if ProcessInfo().environment["DEBUG_LOG"] != nil {
            print(message())
        }
    }
    
    static func parseInput(_ input: String, separatedBy separator: String) -> [String] {
        input.components(separatedBy: separator)
    }
    
    static func parseInputLines(_ input: String) -> [String] {
        input.components(separatedBy: .newlines)
    }
    
    static func parseInputLines<T>(
        _ input: String,
        using transform: (String) throws -> T?
    ) rethrows -> [T] {
        try parseInputLines(input).compactMap(transform)
    }
    
    static func puzzleInput() -> String {
        let fileManager = FileManager()
        
        guard let url = Bundle.module.url(forResource: "Day\(day)",
                                          withExtension: "txt",
                                          subdirectory: "inputs") else {
            fatalError(#"Couldn't find file named "inputs/Day\#(day).txt""#)
        }
        
        guard let data = fileManager.contents(atPath: url.path) else {
            fatalError("Couldn't load data at URL \(url).")
        }
        
        guard let string = String(data: data, encoding: .utf8) else {
            fatalError("Couldn't turn file into text.")
        }
        
        return string
    }
    
}
