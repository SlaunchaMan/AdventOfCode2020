//
//  main.swift
//  AdventOfCode2020
//
//  Created by Jeff Kelley on 12/4/20.
//

import AdventOfCode2020
import ArgumentParser
import Foundation

struct PuzzleSolver: ParsableCommand {
    @Option(name: [.short, .customLong("day")])
    var days: [Int] = []
    
    @Flag(name: .shortAndLong)
    var verbose = false
    
    @Flag(name: .customLong("with-timing"))
    var enableTiming = false
    
    @Flag(name: .customLong("with-examples"))
    var enableExamples = false
    
    func performWithTiming<T>(
        duration: inout TimeInterval,
        _ task: () throws -> T
    ) rethrows -> T {
        let startDate = Date()
        let retVal = try task()
        let endDate = Date()
        
        duration = endDate.timeIntervalSince(startDate)
        return retVal
    }
    
    mutating func run() throws {
        SetLoggingEnabled(verbose)
        
        let outputPrefix = (days.count == 1 ? "" : "\t")
        let puzzles: [Puzzle.Type]
        
        if days.isEmpty {
            puzzles = AllPuzzles
        }
        else {
            puzzles = AllPuzzles.filter {
                days.contains($0.day)
            } 
        }
        
        var totalDuration: TimeInterval = 0
        
        puzzles.forEach { puzzle in
            if puzzles.count > 1 {
                print("Day \(puzzle.day):")
            }
            
            if enableExamples, let puzzle = puzzle as? PuzzleWithExample1.Type {
                print(outputPrefix + "Example 1: \(puzzle.example1())")
            }
            
            var part1Duration: TimeInterval = 0
            let part1Result = performWithTiming(duration: &part1Duration) {
                puzzle.part1()
            }
            
            print(outputPrefix + "Part 1: \(part1Result)")
            
            if enableTiming {
                print(outputPrefix + "Executed in \(part1Duration) seconds.")
                totalDuration += part1Duration
            }
            
            if enableExamples, let puzzle = puzzle as? PuzzleWithExample2.Type {
                print(outputPrefix + "Example 2: \(puzzle.example2())")
            }
            
            var part2Duration: TimeInterval = 0
            let part2Result = performWithTiming(duration: &part2Duration) {
                puzzle.part2()
            }
            
            print(outputPrefix + "Part 2: \(part2Result)")
            
            if enableTiming {
                print(outputPrefix + "Executed in \(part2Duration) seconds.")
                totalDuration += part2Duration
            }
            
            print()
            
            if enableTiming {
                print("Total Duration: \(totalDuration) seconds.")
            }
        }
    }
    
}

PuzzleSolver.main()
