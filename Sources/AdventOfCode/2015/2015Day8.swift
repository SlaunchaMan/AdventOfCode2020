//
//  2015Day8.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/6/20.
//

import Foundation

private let exampleInput =
    """
    ""
    "abc"
    "aaa\\"aaa"
    "\\x27"
    """

extension Year2015 {

    public enum Day8: FullPuzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 8

        private static func decode(_ string: String) -> String {
            var string = string

            if string.hasPrefix("\"") {
                string.removeFirst()
            }

            if string.hasSuffix("\"") {
                string.removeLast()
            }

            var iterator = string.makeIterator()
            var output = ""

            var character = iterator.next()

            while character != nil {
                let nextCharacter = iterator.next()

                switch (character, nextCharacter) {
                case ("\\", "x"):
                    guard let hexFirst = iterator.next(),
                          let hexSecond = iterator.next()
                    else { return output }

                    if let asciiValue = UInt32("\(hexFirst)\(hexSecond)",
                                               radix: 16),
                       let character = UnicodeScalar(asciiValue) {
                        output.append(Character(character))
                    }

                    character = iterator.next()

                case ("\\", "\\"), ("\\", "\""):
                    output.append(nextCharacter!)
                    character = iterator.next()

                default:
                    if let char = character { output.append(char) }
                    character = nextCharacter
                }

            }

            return output
        }

        public static func example1() -> String {
            let original = parseInputLines(exampleInput)
            let decoded = original.map(decode)

            let originalCount = original.map(\.count).reduce(0, +)
            let decodedCount = decoded.map(\.count).reduce(0, +)

            return "\(originalCount - decodedCount)"
        }

        public static func part1() -> String {
            let original = parseInputLines(puzzleInput())
            let decoded = original.map(decode)

            let originalCount = original.map(\.count).reduce(0, +)
            let decodedCount = decoded.map(\.count).reduce(0, +)

            return "\(originalCount - decodedCount)"
        }

        private static func encode(_ string: String) -> String {
            var output = "\""

            for character in string {
                switch character {
                case "\"", "\\":
                    output.append("\\")
                    output.append(character)
                default:
                    output.append(character)
                }
            }

            output.append("\"")

            return output
        }

        public static func example2() -> String {
            let original = parseInputLines(exampleInput)
            let encoded = original.map(encode)

            let originalCount = original.map(\.count).reduce(0, +)
            let encodedCount = encoded.map(\.count).reduce(0, +)

            return "\(encodedCount - originalCount)"
        }

        public static func part2() -> String {
            let original = parseInputLines(puzzleInput())
            let encoded = original.map(encode)

            let originalCount = original.map(\.count).reduce(0, +)
            let encodedCount = encoded.map(\.count).reduce(0, +)

            return "\(encodedCount - originalCount)"
        }

    }

}
