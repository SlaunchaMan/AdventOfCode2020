//
//  2015Day13.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/7/20.
//

import Algorithms
import Foundation

private let exampleInput =
    """
    Alice would gain 54 happiness units by sitting next to Bob.
    Alice would lose 79 happiness units by sitting next to Carol.
    Alice would lose 2 happiness units by sitting next to David.
    Bob would gain 83 happiness units by sitting next to Alice.
    Bob would lose 7 happiness units by sitting next to Carol.
    Bob would lose 63 happiness units by sitting next to David.
    Carol would lose 62 happiness units by sitting next to Alice.
    Carol would gain 60 happiness units by sitting next to Bob.
    Carol would gain 55 happiness units by sitting next to David.
    David would gain 46 happiness units by sitting next to Alice.
    David would lose 7 happiness units by sitting next to Bob.
    David would gain 41 happiness units by sitting next to Carol.
    """

extension Year2015 {

    public enum Day13: PuzzleWithExample1 {

        public static let year: Year.Type = Year2015.self

        public static let day = 13

        private static func parseRules(
            from lines: [String]
        ) -> [String: [String: Int]] {
            lines.reduce(into: [String: [String: Int]]()) {
                let scanner = Scanner(string: $1)

                let penultimateToken = "happiness units by sitting next to "

                guard let name = scanner.scanUpToString(" "),
                      scanner.scanString("would ") != nil,
                      let changeType = scanner.scanUpToString(" "),
                      let changeAmount = scanner.scanInt(),
                      scanner.scanString(penultimateToken) != nil,
                      let changePerson = scanner.scanUpToString(".")
                      else { return }

                let changeSign = (changeType == "lose" ? -1 : 1)

                $0[name, default: [:]][changePerson] = changeSign * changeAmount
            }
        }

        public static func happinessChange(
            seating: [String],
            using rules: [String: [String: Int]]
        ) -> [String: Int] {
            var happinessChanges: [String: Int] = [:]
            var seating = seating

            for _ in 0 ..< seating.count {
                let leftNeighbor = seating[0]
                let person = seating[1]
                let rightNeighbor = seating[2]

                if let leftChange = rules[person]?[leftNeighbor] {
                    happinessChanges[person, default: 0] += leftChange
                }

                if let rightChange = rules[person]?[rightNeighbor] {
                    happinessChanges[person, default: 0] += rightChange
                }

                seating.rotate(toStartAt: 1)
            }

            return happinessChanges
        }

        public static func example1() -> String {
            let rules = parseRules(from: parseInputLines(exampleInput))

            let optimal = rules.keys.permutations().map {
                happinessChange(seating: Array($0), using: rules)
            }.map {
                $0.values.sum()
            }.max()

            return "\(optimal!)"
        }

        public static func part1() -> String {
            let rules = parseRules(from: parseInputLines(puzzleInput()))

            let optimal = rules.keys.permutations().map {
                happinessChange(seating: Array($0), using: rules)
            }.map {
                $0.values.sum()
            }.max()

            return "\(optimal!)"
        }

        public static func part2() -> String {
            let rules = parseRules(from: parseInputLines(puzzleInput()))

            let seating: [String] = rules.keys + ["Me"]

            let optimal = seating.permutations().map {
                happinessChange(seating: $0, using: rules)
            }.map {
                $0.values.sum()
            }.max()

            return "\(optimal!)"
        }

    }

}
