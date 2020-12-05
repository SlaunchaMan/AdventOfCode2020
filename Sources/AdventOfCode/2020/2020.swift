//
//  2020.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/4/20.
//

import Foundation

public enum Year2020: Year {
    public static let year = 2020

    public static var allPuzzles: [Puzzle.Type] = [
        Year2020.Day1.self,
        Year2020.Day2.self,
        Year2020.Day3.self,
        Year2020.Day4.self,
        Year2020.Day5.self
    ]
}
