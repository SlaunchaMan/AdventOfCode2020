//
//  2020Day1.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/4/20.
//

import Foundation

private let exampleInput =
    """
    1721
    979
    366
    299
    675
    1456
    """

extension Year2020 {

    public enum Day1: FullPuzzle {

        public static let year: Year.Type = Year2020.self
        public static let day: Int = 1

        private static func countEntries(_ count: Int,
                                         in array: [Int],
                                         summingTo sum: Int) -> [Int]? {
            if count == 1 {
                return array.first { $0 == sum }.map { [$0] }
            }
            else {
                let tail = Array(array.dropFirst())

                for entry in array where entry < sum {
                    if let entries = countEntries(count - 1,
                                                  in: tail,
                                                  summingTo: sum - entry) {
                        return entries + [entry]
                    }
                }
            }

            return nil
        }

        public static func example1() -> String {
            let input = parseInputLines(exampleInput, using: Int.init)

            guard let entries = countEntries(2, in: input, summingTo: 2020)
            else { fatalError() }

            return "\(entries.reduce(1, *))"
        }

        public static func part1() -> String {
            let part1Input = parseInputLines(puzzleInput(), using: Int.init)

            guard let entries = countEntries(2, in: part1Input, summingTo: 2020)
            else { fatalError() }

            return "\(entries.reduce(1, *))"
        }

        public static func example2() -> String {
            let input = parseInputLines(exampleInput, using: Int.init)
            guard let entries = countEntries(3, in: input, summingTo: 2020)
            else { fatalError() }

            return "\(entries.reduce(1, *))"
        }

        public static func part2() -> String {
            let part2Input = parseInputLines(puzzleInput(), using: Int.init)

            guard let entries = countEntries(3, in: part2Input, summingTo: 2020)
            else { fatalError() }

            return "\(entries.reduce(1, *))"
        }

    }

}
