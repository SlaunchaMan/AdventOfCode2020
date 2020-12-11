//
//  2015Day19.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/11/20.
//

import Foundation
import StringDecoder

private let exampleInput =
    """
    e => H
    e => O
    H => HO
    H => OH
    O => HH
    """

extension Year2015 {

    public enum Day19: FullPuzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 19

        struct Replacement: Decodable {
            let input: String
            let output: String
        }

        private static func replacementDecoder() -> StringDecoder {
            StringDecoder(formatString: "$(input) => $(output)")
        }

        private static func replacements(
            for string: String,
            using replacements: [Replacement]
        ) -> Set<String> {
            var result: Set<String> = []

            for replacement in replacements {
                for range in string.allRanges(of: replacement.input) {
                    var output = string
                    output.replaceSubrange(range, with: replacement.output)
                    result.insert(output)
                }
            }

            return result
        }

        public static func example1() -> String {
            let decoder = replacementDecoder()
            let replacements = parseInputLines(exampleInput) {
                try? decoder.decode(Replacement.self, from: $0)
            }

            let distinctMolecules = self.replacements(for: "HOH",
                                                      using: replacements)

            return "\(distinctMolecules.count)"
        }

        public static func part1() -> String {
            var inputLines = parseInputLines(puzzleInput())

            let calibration = inputLines.removeLast()

            let decoder = replacementDecoder()
            let replacements = inputLines.compactMap {
                try? decoder.decode(Replacement.self, from: $0)
            }

            let distinctMolecules = self.replacements(for: calibration,
                                                      using: replacements)

            return "\(distinctMolecules.count)"
        }

        private static func fewestReplacements(
            toReach target: String,
            using replacements: [Replacement]
        ) -> Int {
            var workingItem = target
            var iterations = 0

            repeat {
                for replacement in replacements {
                    if let range = workingItem.range(of: replacement.output) {
                        if replacement.input == "e" {
                            if workingItem == replacement.output {
                                return iterations + 1
                            }
                        }
                        else {
                            workingItem.replaceSubrange(range,
                                                        with: replacement.input)

                            iterations += 1
                        }
                    }
                }
            } while workingItem != "e"

            return iterations
        }

        public static func example2() -> String {
            let decoder = replacementDecoder()
            let replacements = parseInputLines(exampleInput) {
                try? decoder.decode(Replacement.self, from: $0)
            }

            return "\(fewestReplacements(toReach: "HOH", using: replacements))"
        }

        public static func part2() -> String {
            var inputLines = parseInputLines(puzzleInput())

            let med = inputLines.removeLast()

            let decoder = replacementDecoder()
            let replacements = inputLines.compactMap {
                try? decoder.decode(Replacement.self, from: $0)
            }

            return "\(fewestReplacements(toReach: med, using: replacements))"
        }

    }

}
