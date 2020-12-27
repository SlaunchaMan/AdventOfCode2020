//
//  2016Day7.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/16/20.
//

import Foundation

extension Year2016 {

    public enum Day7: TwoPartPuzzle {

        public static let year: Year.Type = Year2016.self

        public static let day = 7

        struct IPV7Address {

            let supernetSequences: [String]
            let subnetSequences: [String]

            init(string: String) {
                let scanner = Scanner(string: string)

                var supernetSequences: [String] = []
                var subnetSequences: [String] = []

                while !scanner.isAtEnd {
                    if let supernetSequence = scanner.scanUpToString("[") {
                        supernetSequences.append(supernetSequence)
                    }

                    if let subnetSequence = scanner.scanUpToString("]") {
                        subnetSequences.append(subnetSequence)
                    }
                }

                self.supernetSequences = supernetSequences
                self.subnetSequences = subnetSequences
            }

            var supportsTLS: Bool {
                supernetSequences.contains(where: \.hasABBAPattern) &&
                    !subnetSequences.contains(where: \.hasABBAPattern)
            }

            var supportsSSL: Bool {
                supernetSequences.flatMap(\.abaPatterns).contains { pattern in
                    let babPattern = String([pattern[1],
                                             pattern[0],
                                             pattern[1]])

                    return subnetSequences.contains { $0.contains(babPattern) }
                }
            }

        }

        public static func part1() -> String {
            let ipAddresses = parseInputLines(puzzleInput(),
                                              using: IPV7Address.init)

            return "\(ipAddresses.count(where: \.supportsTLS))"
        }

        public static func part2() -> String {
            let ipAddresses = parseInputLines(puzzleInput(),
                                              using: IPV7Address.init)

            return "\(ipAddresses.count(where: \.supportsSSL))"
        }

    }

}
