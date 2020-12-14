//
//  2016Day2.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/13/20.
//

import Foundation

private let exampleInput =
    """
    ULL
    RRDDD
    LURDL
    UUUUD
    """

extension Year2016 {

    public enum Day2: Puzzle {

        public static let year: Year.Type = Year2016.self

        public static let day = 2

        private static func key(
            on keypad: [[Character?]],
            startingAt initialDigit: Character = "5",
            directions: [Collection2DDirection]
        ) -> Character {
            guard var position = keypad.firstPosition(of: initialDigit)
            else { return initialDigit }

            for direction in directions {
                if let nextPosition = keypad.position(movingTo: direction,
                                                      from: position),
                   keypad[nextPosition.outerIndex][nextPosition.innerIndex]
                    != nil {
                    position = nextPosition
                }
            }

            return keypad[position.outerIndex][position.innerIndex]!
        }

        private static let basicKeypad =
            """
            123
            456
            789
            """

        private static let expandedKeypad =
            """
            xx1xx
            x234x
            56789
            xABCx
            xxDxx
            """

        private static func keypadLine(_ string: String) -> [Character?] {
            string.map {
                switch $0 {
                case "x": return nil
                default: return $0
                }
            }
        }

        private static func instructionLine(
            _ string: String
        ) -> [Collection2DDirection] {
            string.compactMap { character in
                switch character {
                case "U": return .up
                case "D": return .down
                case "L": return .left
                case "R": return .right
                default: return nil
                }
            }
        }

        private static func combination(
            for keypad: [[Character?]],
            directions: [[Collection2DDirection]]
        ) -> String {
            var key: Character = "5"
            var combination = ""

            for direction in directions {
                let nextDigit = self.key(on: keypad,
                                         startingAt: key,
                                         directions: direction)
                combination.append(nextDigit)

                key = nextDigit
            }

            return combination
        }

        public static func example1() -> String {
            let keypad = parseInputLines(basicKeypad, using: keypadLine)

            let directions: [[Collection2DDirection]] = parseInputLines(
                exampleInput,
                using: instructionLine
            )

            return combination(for: keypad, directions: directions)
        }

        public static func part1() -> String {
            let keypad = parseInputLines(basicKeypad, using: keypadLine)

            let directions: [[Collection2DDirection]] = parseInputLines(
                puzzleInput(),
                using: instructionLine
            )

            return combination(for: keypad, directions: directions)
        }

        public static func example2() -> String {
            let keypad = parseInputLines(expandedKeypad, using: keypadLine)

            let directions: [[Collection2DDirection]] = parseInputLines(
                exampleInput,
                using: instructionLine
            )

            return combination(for: keypad, directions: directions)
        }

        public static func part2() -> String {
            let keypad = parseInputLines(expandedKeypad, using: keypadLine)

            let directions: [[Collection2DDirection]] = parseInputLines(
                puzzleInput(),
                using: instructionLine
            )

            return combination(for: keypad, directions: directions)
        }

    }

}
