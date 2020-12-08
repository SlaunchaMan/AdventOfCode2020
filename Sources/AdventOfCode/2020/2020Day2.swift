//
//  2020Day2.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/4/20.
//

import Foundation
import StringDecoder

private let exampleInput =
    """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """

extension String {

    func count(of character: Character) -> Int {
        count { $0 == character }
    }

}

extension Year2020 {

    public enum Day2: FullPuzzle {

        public static let year: Year.Type = Year2020.self
        public static let day: Int = 2

        struct Requirement: Decodable, CustomStringConvertible {
            let firstNumber: Int
            let secondNumber: Int
            let letter: String
            let password: String

            var range: ClosedRange<Int> { firstNumber...secondNumber }

            func evaluatePart1() -> Bool {
                range.contains(password.count(of: letter.first!))
            }

            func evaluatePart2() -> Bool {
                let firstIndex = password.index(password.startIndex,
                                                offsetBy: firstNumber - 1)

                let secondIndex = password.index(password.startIndex,
                                                 offsetBy: secondNumber - 1)

                switch (password[firstIndex], password[secondIndex]) {
                case (letter.first, letter.first): return false
                case (letter.first, _): return true
                case (_, letter.first): return true
                default: return false
                }
            }

            var description: String {
                "\(range.lowerBound)-\(range.upperBound) \(letter)"
            }
        }

        static func parseInputLine(_ line: String) -> Requirement? {
            let decoder = StringDecoder(
                formatString:
                    "$(firstNumber)-$(secondNumber) $(letter): $(password)"
            )

            return try? decoder.decode(Requirement.self, from: line)
        }

        public static func example1() -> String {
            let input = parseInputLines(exampleInput, using: parseInputLine)

            return "\(input.count { $0.evaluatePart1() })"
        }

        public static func part1() -> String {
            let input = parseInputLines(puzzleInput(), using: parseInputLine)
            return "\(input.count { $0.evaluatePart1() })"

        }

        public static func example2() -> String {
            let input = parseInputLines(exampleInput, using: parseInputLine)
            return "\(input.count { $0.evaluatePart2() })"
        }

        public static func part2() -> String {
            let input = parseInputLines(puzzleInput(), using: parseInputLine)
            return "\(input.count { $0.evaluatePart2() })"
        }

    }

}
