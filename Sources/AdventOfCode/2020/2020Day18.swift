//
//  2020Day18.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/18/20.
//

import Foundation

private let exampleInput =
    """
    1 + (2 * 3) + (4 * (5 + 6))
    2 * 3 + (4 * 5)
    5 + (8 * 3 + 9 + 3 * 4 * 3)
    5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
    ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
    """

extension CharacterSet {
    static let parens = CharacterSet(charactersIn: "()")
}

extension Year2020 {

    public enum Day18: FullPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 18

        private static func parseArgument(_ scanner: Scanner) -> Int? {
            var parens = 0
            if scanner.string[scanner.currentIndex] == "(" {
                parens += 1

                scanner.currentIndex =
                    scanner.string.index(after: scanner.currentIndex)

                var innerContents = ""

                while parens > 0,
                      let nextCharacter = scanner.scanCharacter() {
                    switch nextCharacter {
                    case ")":
                        parens -= 1
                        if parens > 0 {
                            innerContents.append(nextCharacter)
                        }
                    case "(":
                        parens += 1
                        fallthrough
                    default:
                        innerContents.append(nextCharacter)
                    }
                }

                return evaluatePart1(innerContents)
            }
            else if let int = scanner.scanInt() {
                return int
            }
            else {
                return nil
            }
        }

        private static func evaluatePart1(_ string: String) -> Int {
            var string = string

            string.removeAll { character in
                character.unicodeScalars.allSatisfy {
                    CharacterSet.whitespaces.contains($0)
                }
            }

            let scanner = Scanner(string: string)

            let startIndex = scanner.currentIndex

            guard var currentValue = parseArgument(scanner) else {
                fatalError()
            }

            while let op = scanner.scanCharacter(),
                  let nextArgument = parseArgument(scanner) {
                switch op {
                case "+": currentValue += nextArgument
                case "*": currentValue *= nextArgument
                default: fatalError("Unknown operator \(op)")
                }

                var newString = string

                newString.replaceSubrange(
                    startIndex ..< scanner.currentIndex,
                    with: "\(currentValue)"
                )

                if newString == string {
                    return currentValue
                }
                else {
                    return evaluatePart1(newString)
                }
            }

            return currentValue
        }

        public static func example1() -> String {
            parseInputLines(exampleInput).map {
                "\($0) becomes \(evaluatePart1($0))."
            }.joined(separator: "\n")
        }

        public static func part1() -> String {
            return "\(parseInputLines(puzzleInput()).sum(evaluatePart1))"
        }

        enum ArithmeticComponent: Equatable {
            case number(Int)
            case `operator`(Character)

            var value: Int? {
                switch self {
                case .number(let value): return value
                default: return nil
                }
            }
        }

        private static func solve(_ components: [ArithmeticComponent]) -> Int {
            if components.count == 1 {
                return components[0].value!
            }

            let operations = components.indexed().filter {
                if case .operator = $0.element { return true }
                else { return false }
            }

            let firstAddition = operations
                .first(where: { $0.element == .operator("+") })

            if let (index, _) = firstAddition,
               let lhs = components[index - 1].value,
               let rhs = components[index + 1].value {
                var nextComponents = components

                nextComponents.replaceSubrange(
                    index - 1 ... index + 1,
                    with: [.number(lhs + rhs)]
                )

                return solve(nextComponents)
            }
            else {
                let firstMultiplication = operations
                    .first(where: { $0.element == .operator("*") })

                if let (index, _) = firstMultiplication,
                   let lhs = components[index - 1].value,
                   let rhs = components[index + 1].value {
                    var nextComponents = components

                    nextComponents.replaceSubrange(
                        index - 1 ... index + 1,
                        with: [.number(lhs * rhs)]
                    )

                    return solve(nextComponents)
                }
                else {
                    fatalError()
                }
            }
        }

        private static func evaluatePart2(_ string: String) -> Int {
            var string = string

            string.removeAll { character in
                character.unicodeScalars.allSatisfy {
                    CharacterSet.whitespaces.contains($0)
                }
            }

            if let openingIndex = string.firstIndex(of: "(") {
                var newString = string
                var innerString = ""

                let scanner = Scanner(string: string)
                scanner.currentIndex = string.index(after: openingIndex)

                var level = 1

                while level > 0 {
                    if let nextBit = scanner.scanUpToCharacters(from: .parens) {
                        innerString.append(nextBit)
                    }

                    switch scanner.scanCharacter() {
                    case "(":
                        level += 1
                        innerString.append("(")
                    case ")":
                        level -= 1
                        if level > 0 {
                            innerString.append(")")
                        }
                    default:
                        fatalError("Expected parens")
                    }
                }

                let endIndex = scanner.currentIndex

                newString.replaceSubrange(openingIndex ..< endIndex,
                                          with: "\(evaluatePart2(innerString))")

                return evaluatePart2(newString)
            }
            else {
                let scanner = Scanner(string: string)

                var components: [ArithmeticComponent] = []

                while !scanner.isAtEnd {
                    if let number = scanner.scanInt() {
                        components.append(.number(number))
                    }
                    if let `operator` = scanner.scanCharacter(),
                       ["*", "+"].contains(`operator`) {
                        components.append(.operator(`operator`))
                    }
                }

                return solve(components)
            }
        }

        public static func example2() -> String {
            parseInputLines(exampleInput).map {
                "\($0) becomes \(evaluatePart2($0))."
            }.joined(separator: "\n")
        }

        public static func part2() -> String {
            return "\(parseInputLines(puzzleInput()).sum(evaluatePart2))"
        }

    }

}
