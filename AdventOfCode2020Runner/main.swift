//
//  main.swift
//  AdventOfCode2020
//
//  Created by Jeff Kelley on 12/4/20.
//

import AdventOfCode2020

for (index, puzzle) in AllPuzzles.enumerated() {
    print("Day \(index + 1):")
    
    if let puzzle = puzzle as? PuzzleWithExample1.Type {
        print("\tExample 1: \(puzzle.example1())")
    }

    print("\tPart 1: \(puzzle.part1())")

    if let puzzle = puzzle as? PuzzleWithExample2.Type {
        print("\tExample 2: \(puzzle.example2())")
    }
    
    print("\tPart 2: \(puzzle.part2())")
    print()
}
