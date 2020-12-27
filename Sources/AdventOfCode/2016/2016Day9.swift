//
//  2016Day9.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/16/20.
//

import Foundation

extension Year2016 {

    public enum Day9: TwoPartPuzzle {

        public static let year: Year.Type = Year2016.self

        public static let day = 9

        private static func decompressedLengthPart1<T: StringProtocol>(
            of string: T
        ) -> Int {
            var length = 0
            var index = string.startIndex

            while index != string.endIndex {
                if string[index] == "(" {
                    index = string.index(after: index)

                    let scanner = Scanner(string: String(string[index...]))

                    guard let characters = scanner.scanInt(),
                          scanner.scanCharacter() == "x",
                          let repeats = scanner.scanInt()
                    else { fatalError() }

                    length += (characters * repeats)

                    while string[index] != ")" {
                        index = string.index(after: index)
                    }

                    index = string.index(index, offsetBy: characters + 1)
                }
                else {
                    length += 1
                    index = string.index(after: index)
                }
            }

            return length
        }

        public static func part1() -> String {
            let whitespaces = CharacterSet.whitespacesAndNewlines

            let filteredInput = puzzleInput().filter {
                !$0.unicodeScalars.allSatisfy {
                    whitespaces.contains($0)
                }
            }

            return "\(decompressedLengthPart1(of: filteredInput))"
        }

        private static func decompressedLengthPart2<T: StringProtocol>(
            of string: T
        ) -> Int {
            var length = 0
            var index = string.startIndex

            while index != string.endIndex {
                if string[index] == "(" {
                    index = string.index(after: index)

                    let scanner = Scanner(string: String(string[index...]))

                    guard let characters = scanner.scanInt(),
                          scanner.scanCharacter() == "x",
                          let repeats = scanner.scanInt()
                    else { fatalError() }

                    while string[index] != ")" {
                        index = string.index(after: index)
                    }

                    index = string.index(after: index)

                    let segmentEndIndex = string.index(index,
                                                       offsetBy: characters)

                    length += repeats * decompressedLengthPart2(
                        of: string[index ..< segmentEndIndex]
                    )

                    index = segmentEndIndex
                }
                else {
                    length += 1
                    index = string.index(after: index)
                }
            }

            return length
        }

        public static func part2() -> String {
            let whitespaces = CharacterSet.whitespacesAndNewlines

            let filteredInput = puzzleInput().filter {
                !$0.unicodeScalars.allSatisfy {
                    whitespaces.contains($0)
                }
            }

            return "\(decompressedLengthPart2(of: filteredInput))"
        }

    }

}
