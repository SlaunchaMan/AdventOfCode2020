//
//  2015Day24.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/12/20.
//

import Algorithms
import Foundation

private let exampleInput =
    """
    1
    2
    3
    4
    5
    7
    8
    9
    10
    11
    """

extension Year2015 {

    public enum Day24: Puzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 24

        private static func minimumQuantumEntanglement(
            of packages: [Int],
            separatedIntoGroups groups: Int = 3
        ) -> Int? {
            let sum = packages.sum()
            let targetWeight = sum / groups

            var minimumCount = 0
            var combinations: Combinations<[Int]>

            repeat {
                minimumCount += 1
                combinations = packages.combinations(ofCount: minimumCount)
            } while !combinations.contains { $0.sum() == targetWeight }

            guard let minimumEntanglement = combinations
                    .filter({ $0.sum() == targetWeight })
                    .map({ $0.reduce(1, *) })
                    .min()
            else { return nil }

            return minimumEntanglement
        }

        public static func example1() -> String {
            let packages = parseInputLines(exampleInput, using: Int.init)
            return "\(minimumQuantumEntanglement(of: packages)!)"
        }

        public static func part1() -> String {
            let packages = parseInputLines(puzzleInput(), using: Int.init)
            return "\(minimumQuantumEntanglement(of: packages)!)"
        }

        public static func example2() -> String {
            let packages = parseInputLines(exampleInput, using: Int.init)

            let entanglement = minimumQuantumEntanglement(
                of: packages,
                separatedIntoGroups: 4
            )

            return "\(entanglement!)"
        }

        public static func part2() -> String {
            let packages = parseInputLines(puzzleInput(), using: Int.init)

            let entanglement = minimumQuantumEntanglement(
                of: packages,
                separatedIntoGroups: 4
            )

            return "\(entanglement!)"
        }

    }

}
