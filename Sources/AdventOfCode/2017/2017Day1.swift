//
//  2017Day1.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/27/20.
//

import Foundation

private let exampleInput1 =
    """
    1122
    1111
    1234
    91212129
    """

private let exampleInput2 =
    """
    1212
    1221
    123425
    123123
    12131415
    """

extension Year2017 {

    public enum Day1: FullPuzzle {

        public static let year: Year.Type = Year2017.self

        public static let day = 1

        private static func parseInput(_ input: String) -> [UInt8] {
            input.map(String.init).compactMap(UInt8.init)
        }

        private static func captchaPart1(_ input: [UInt8]) -> Int {
            var sum = 0

            for (index, value) in input.enumerated()
            where input[(index + 1) % input.count] == value {
                sum += Int(value)
            }

            return sum
        }

        public static func example1() -> String {
            parseInputLines(exampleInput1, using: parseInput)
                .map(captchaPart1)
                .map(String.init)
                .joined(separator: ",")
        }

        public static func part1() -> String {
            String(captchaPart1(parseInput(puzzleInput())))
        }

        private static func captchaPart2(_ input: [UInt8]) -> Int {
            var sum = 0

            for (index, value) in input.enumerated()
            where input[(index + (input.count / 2)) % input.count] == value {
                sum += Int(value)
            }

            return sum
        }

        public static func example2() -> String {
            parseInputLines(exampleInput2, using: parseInput)
                .map(captchaPart2)
                .map(String.init)
                .joined(separator: ",")
        }

        public static func part2() -> String {
            String(captchaPart2(parseInput(puzzleInput())))
        }

    }

}
