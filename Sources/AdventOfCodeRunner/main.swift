//
//  main.swift
//  AdventOfCodeRunner
//
//  Created by Jeff Kelley on 12/4/20.
//

import AdventOfCode
import ArgumentParser
import Foundation

struct PuzzleSolver: ParsableCommand {

    enum ParseError: Error, CustomStringConvertible {
        case invalidDays(year: Int, days: [Int])
        case invalidYear(year: Int)

        var description: String {
            switch self {
            case let .invalidDays(year, days) where days.count == 1:
                return "Invalid day for year \(year): \(days[0])"
            case let .invalidDays(year, days):
                let formatted = days.map(String.init).joined(separator: ", ")
                return "Invalid days entered for year \(year): \(formatted)"
            case let .invalidYear(year):
                return "No puzzles found for year \(year)"
            }
        }
    }

    @Option(name: .shortAndLong)
    var year: Int?

    @Option(name: [.short, .customLong("day")])
    var days: [Int] = []

    @Flag(name: .shortAndLong)
    var verbose = false

    @Flag(name: .customLong("with-timing"))
    var enableTiming = false

    @Flag(name: .customLong("with-examples"))
    var enableExamples = false

    var effectiveYear: Year.Type? {
        if let year = year {
            return allYears.first { $0.year == year }
        }
        else if !days.isEmpty {
            return Year2020.self
        }
        else {
            return nil
        }
    }

    func puzzlesToRun() throws -> [Puzzle.Type] {
        if let effectiveYear = effectiveYear {
            if days.isEmpty {
                return effectiveYear.allPuzzles
            }
            else {
                return effectiveYear.allPuzzles.filter {
                    days.contains($0.day)
                }
            }
        }
        else if let year = year {
            throw ParseError.invalidYear(year: year)
        }
        else {
            return allYears.flatMap { $0.allPuzzles }
        }
    }

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

    mutating func validate() throws {
        if !days.isEmpty {
            let year = effectiveYear ?? Year2020.self

            let validDays = Set(year.allPuzzles.map { $0.day })
            let invalidDays = Set(days).subtracting(validDays).sorted()

            if !invalidDays.isEmpty {
                throw ParseError.invalidDays(year: year.year, days: invalidDays)
            }
        }

    }

    mutating func run() throws {
        if verbose {
            setLoggingEnabled()
        }

        let outputPrefix = (days.count == 1 ? "" : "\t")
        let puzzles = try puzzlesToRun()

        var totalDuration: TimeInterval = 0

        var iterator = puzzles.makeIterator()
        var nextPuzzle = iterator.next()

        while let puzzle = nextPuzzle {
            if puzzles.count > 1 {
                print("\(puzzle.year.year) Day \(puzzle.day):")
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

            nextPuzzle = iterator.next()

            if enableTiming || nextPuzzle != nil {
                print()
            }
        }

        if enableTiming {
            print("Total Duration: \(totalDuration) seconds.")
        }
    }

}

PuzzleSolver.main()
