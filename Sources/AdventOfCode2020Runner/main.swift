//
//  main.swift
//  AdventOfCode2020
//
//  Created by Jeff Kelley on 12/4/20.
//

import AdventOfCode2020
import ArgumentParser

struct PuzzleSolver: ParsableCommand {
    @Option(name: [.short, .customLong("day")])
    var days: [Int] = []
    
    @Flag(name: .shortAndLong)
    var verbose = false
    
    mutating func run() throws {
        let puzzles: [Puzzle.Type]
        
        if days.isEmpty {
            puzzles = AllPuzzles
        }
        else {
            puzzles = AllPuzzles.filter {
                days.contains($0.day)
            } 
        }
        
        puzzles.forEach { puzzle in
            print("Day \(puzzle.day):")
            
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
    }
    
}

PuzzleSolver.main()
