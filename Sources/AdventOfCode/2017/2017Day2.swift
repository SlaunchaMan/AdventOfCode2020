//
//  2017Day2.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/27/20.
//

import Algorithms
import Foundation

private let exampleInput1 =
    """
    5 1 9 5
    7 5 3
    2 4 6 8
    """

private let exampleInput2 =
    """
    5 9 2 8
    9 4 7 3
    3 8 6 5
    """

extension Year2017 {

    public enum Day2: FullPuzzle {

        public static let year: Year.Type = Year2017.self

        public static let day = 2

        private static func spreadsheetLine(_ input: String) -> [Int] {
            input.split(separator: " ", omittingEmptySubsequences: true)
                .map(String.init)
                .compactMap(Int.init)
        }

        private static func captchaPart1(_ input: [[Int]]) -> Int {
            input.map { $0.max()! - $0.min()! }.sum()
        }

        public static func example1() -> String {
            let spreadsheet = parseInputLines(exampleInput1,
                                              using: spreadsheetLine)

            return "\(captchaPart1(spreadsheet))"
        }

        public static func part1() -> String {
            let spreadsheet = parseInputLines(puzzleInput(),
                                              using: spreadsheetLine)

            return "\(captchaPart1(spreadsheet))"
        }

        private static func captchaPart2(_ input: [[Int]]) -> Int {
            input.map {
                $0.sorted().combinations(ofCount: 2)
                    .lazy
                    .filter { $0[1] % $0[0] == 0 }
                    .map { $0[1] / $0[0] }
                    .first ?? 0
            }.sum()
        }

        public static func example2() -> String {
            let spreadsheet = parseInputLines(exampleInput2,
                                              using: spreadsheetLine)

            return "\(captchaPart2(spreadsheet))"
        }

        public static func part2() -> String {
            let spreadsheet = parseInputLines(puzzleInput(),
                                              using: spreadsheetLine)

            return "\(captchaPart2(spreadsheet))"
        }

    }

}
