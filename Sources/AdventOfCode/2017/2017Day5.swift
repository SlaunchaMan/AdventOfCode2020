//
//  2017Day5.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/27/20.
//

import Foundation

private let exampleInput =
    """
    0
    3
    0
    1
    -3
    """

extension Year2017 {

    public enum Day5: FullPuzzle {

        public static let year: Year.Type = Year2017.self

        public static let day = 5

        private static func stepsToExit1(_ jumps: [Int]) -> Int {
            var jumps = jumps
            var pc = 0

            for step in 1... {
                let jump = jumps[pc]
                jumps[pc] += 1
                pc += jump

                if pc >= jumps.count {
                    return step
                }
            }

            preconditionFailure()
        }

        public static func example1() -> String {
            "\(stepsToExit1(parseInputLines(exampleInput, using: Int.init)))"
        }

        public static func part1() -> String {
            "\(stepsToExit1(parseInputLines(puzzleInput(), using: Int.init)))"
        }

        private static func stepsToExit2(_ jumps: [Int]) -> Int {
            var jumps = jumps
            var pc = 0

            for step in 1... {
                let jump = jumps[pc]

                if jump >= 3 {
                    jumps[pc] -= 1
                }
                else {
                    jumps[pc] += 1
                }

                pc += jump

                if pc >= jumps.count {
                    return step
                }
            }

            preconditionFailure()
        }

        public static func example2() -> String {
            "\(stepsToExit2(parseInputLines(exampleInput, using: Int.init)))"
        }

        public static func part2() -> String {
            "\(stepsToExit2(parseInputLines(puzzleInput(), using: Int.init)))"
        }

    }

}
