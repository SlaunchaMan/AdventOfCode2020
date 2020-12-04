//
//  Util.swift
//  AdventOfCode2020
//
//  Created by Jeff Kelley on 12/4/20.
//

import Foundation

func parseInput(_ input: String, separatedBy separator: String) -> [String] {
    input.components(separatedBy: separator)
}

func parseInputLines(_ input: String) -> [String] {
    input.components(separatedBy: .newlines)
}

func parseInputLines<T>(
    _ input: String,
    using transform: (String) throws -> T?
) rethrows -> [T] {
    try parseInputLines(input).compactMap(transform)
}

func inputForDay(_ day: Int) -> String {
    let fileManager = FileManager()
    
    let path = "\(fileManager.currentDirectoryPath)/inputs/Day\(day).txt"
    
    guard let data = fileManager.contents(atPath: path) else {
        fatalError("Couldn't load data.")
    }
    
    guard let string = String(data: data, encoding: .utf8) else {
        fatalError("Couldn't turn file into text.")
    }
    
    return string
}
