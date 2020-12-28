//
//  2017Day4.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/27/20.
//

import Foundation

private let exampleInput1 =
    """
    aa bb cc dd ee
    aa bb cc dd aa
    aa bb cc dd aaa
    """

private let exampleInput2 =
    """
    abcde fghij
    abcde xyz ecdab
    a ab abc abd abf abj
    iiii oiii ooii oooi oooo
    oiii ioii iioi iiio
    """

extension Year2017 {

    public enum Day4: FullPuzzle {

        public static let year: Year.Type = Year2017.self

        public static let day = 4

        private static func validPassphrasePart1(_ string: String) -> Bool {
            let components = string.components(separatedBy: .whitespaces)

            return components.count == Set(components).count
        }

        public static func example1() -> String {
            let validPassphrases = parseInputLines(
                exampleInput1,
                using: validPassphrasePart1
            )
            .count(of: true)

            return "\(validPassphrases)"
        }

        public static func part1() -> String {
            let validPassphrases = parseInputLines(
                puzzleInput(),
                using: validPassphrasePart1
            )
            .count(of: true)

            return "\(validPassphrases)"
        }

        private static func validPassphrasePart2(_ string: String) -> Bool {
            let components = string.components(separatedBy: .whitespaces)

            return components.count == Set(components).count &&
                Set(components.map { $0.histogram() }).count == components.count
        }

        public static func example2() -> String {
            let validPassphrases = parseInputLines(
                exampleInput2,
                using: validPassphrasePart2
            )
            .count(of: true)

            return "\(validPassphrases)"
        }

        public static func part2() -> String {
            let validPassphrases = parseInputLines(
                puzzleInput(),
                using: validPassphrasePart2
            )
            .count(of: true)

            return "\(validPassphrases)"
        }

    }

}
