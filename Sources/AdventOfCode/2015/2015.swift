//
//  2015.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation

public enum Year2015: Year {
    public static let year = 2015

    public static var allPuzzles: [Puzzle.Type] = [
        Year2015.Day1.self,
        Year2015.Day2.self
    ]
}
