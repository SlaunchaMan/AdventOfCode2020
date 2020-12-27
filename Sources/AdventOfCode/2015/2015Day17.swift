//
//  2015Day17.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/9/20.
//

import Foundation

private let exampleInput =
    """
    20
    15
    10
    5
    5
    """

extension Year2015 {

    public enum Day17: TwoPartPuzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 17

        private static func combinations(filling target: Int,
                                         into containers: [Int]) -> [[Int]] {
            var result: [[Int]] = []

            for i in 2 ..< containers.count {
                let matchingCombinations = containers
                    .combinations(ofCount: i)
                    .filter { $0.sum() == target }

                result.append(contentsOf: matchingCombinations)
            }

            return result
        }

        public static func example1() -> String {
            let containers = parseInputLines(exampleInput, using: Int.init)
            let combinations = self.combinations(filling: 25, into: containers)

            return "\(combinations.count)"
        }

        public static func part1() -> String {
            let containers = parseInputLines(puzzleInput(), using: Int.init)
            let combinations = self.combinations(filling: 150, into: containers)

            return "\(combinations.count)"
        }

        public static func example2() -> String {
            let containers = parseInputLines(exampleInput, using: Int.init)
            let combinations = self.combinations(filling: 25, into: containers)

            guard let minimum = combinations.map(\.count).min()
            else { fatalError() }

            let combinationsOfMinimumCount = combinations.filter {
                $0.count == minimum
            }

            return "\(combinationsOfMinimumCount.count)"
        }

        public static func part2() -> String {
            let containers = parseInputLines(puzzleInput(), using: Int.init)
            let combinations = self.combinations(filling: 150, into: containers)

            guard let minimum = combinations.map(\.count).min()
            else { fatalError() }

            let combinationsOfMinimumCount = combinations.filter {
                $0.count == minimum
            }

            return "\(combinationsOfMinimumCount.count)"
        }

    }

}
