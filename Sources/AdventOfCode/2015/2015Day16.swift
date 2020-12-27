//
//  2015Day16.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/9/20.
//

import Foundation

extension Year2015 {

    public enum Day16: TwoPartPuzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 16

        struct AuntSue {
            let id: Int
            let attributes: [String: Int]

            func matchesAttributesPart1(
                _ otherAttributes: [String: Int]
            ) -> Bool {
                attributes.allSatisfy { key, value in
                    value == otherAttributes[key]
                }
            }

            func matchesAttributesPart2(
                _ otherAttributes: [String: Int]
            ) -> Bool {
                for (key, value) in attributes {
                    if key == "cats" || key == "trees" {
                        if value <= otherAttributes[key]! {
                            return false
                        }
                    }
                    else if key == "pomeranians" || key == "goldfish" {
                        if value >= otherAttributes[key]! {
                            return false
                        }
                    }
                    else if value != otherAttributes[key] {
                        return false
                    }
                }

                return true
            }
        }

        private static func parseAuntSue(from line: String) -> AuntSue? {
            let scanner = Scanner(string: line)

            guard scanner.scanString("Sue ") != nil,
                  let id = scanner.scanInt(),
                  scanner.scanString(": ") != nil else {
                return nil
            }

            var attributes: [String: Int] = [:]

            while !scanner.isAtEnd,
                  let attribute = scanner.scanUpToString(":"),
                  scanner.scanString(":") != nil,
                  let value = scanner.scanInt() {
                attributes[attribute] = value

                _ = scanner.scanString(", ")
            }

            if attributes.isEmpty { return nil }

            return AuntSue(id: id, attributes: attributes)
        }

        private static func knownAttributes() -> [String: Int] {
            let knownAttributes =
                """
                children: 3
                cats: 7
                samoyeds: 2
                pomeranians: 3
                akitas: 0
                vizslas: 0
                goldfish: 5
                trees: 3
                cars: 2
                perfumes: 1
                """

            return parseInputLines(knownAttributes).reduce(into: [:]) {
                let scanner = Scanner(string: $1)

                if let attribute = scanner.scanUpToString(":"),
                   scanner.scanString(": ") != nil,
                   let value = scanner.scanInt() {
                    $0[attribute] = value
                }
            }
        }

        public static func part1() -> String {
            let auntsSue = parseInputLines(puzzleInput(),
                                           using: parseAuntSue(from:))

            let attributes = knownAttributes()

            guard let responsibleAunt = auntsSue
                .filter({ $0.matchesAttributesPart1(attributes) })
                .first
            else { fatalError() }

            return "\(responsibleAunt.id)"
        }

        public static func part2() -> String {
            let auntsSue = parseInputLines(puzzleInput(),
                                           using: parseAuntSue(from:))

            let attributes = knownAttributes()

            guard let responsibleAunt = auntsSue
                .filter({ $0.matchesAttributesPart2(attributes) })
                .first
            else { fatalError() }

            return "\(responsibleAunt.id)"
        }

    }

}
