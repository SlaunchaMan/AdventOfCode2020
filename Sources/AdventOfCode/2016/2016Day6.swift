//
//  2016Day6.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/16/20.
//

import Foundation

private let exampleInput =
    """
    eedadn
    drvtee
    eandsr
    raavrd
    atevrs
    tsrnev
    sdttsa
    rasrtv
    nssdts
    ntnada
    svetve
    tesnvt
    vntsnd
    vrdear
    dvrsen
    enarar
    """

extension Year2016 {

    public enum Day6: TwoPartPuzzle {

        public static let year: Year.Type = Year2016.self

        public static let day = 6

        private static func decodePart1(messages: [String]) -> String {
            var result = ""

            for offset in 0 ..< (messages.map(\.count).min() ?? 1) {
                let lettersAtOffset = messages.map { line in
                    line[line.index(line.startIndex, offsetBy: offset)]
                }

                if let mostCommonLetter = lettersAtOffset.mostCommonElement() {
                    result.append(mostCommonLetter)
                }
            }

            return result
        }

        public static func example1() -> String {
            decodePart1(messages: parseInputLines(exampleInput))
        }

        public static func part1() -> String {
            decodePart1(messages: parseInputLines(puzzleInput()))
        }

        private static func decodePart2(messages: [String]) -> String {
            var result = ""

            for offset in 0 ..< (messages.map(\.count).min() ?? 1) {
                let lettersAtOffset = messages.map { line in
                    line[line.index(line.startIndex, offsetBy: offset)]
                }

                if let mostCommonLetter = lettersAtOffset.leastCommonElement() {
                    result.append(mostCommonLetter)
                }
            }

            return result
        }

        public static func example2() -> String {
            decodePart2(messages: parseInputLines(exampleInput))
        }

        public static func part2() -> String {
            decodePart2(messages: parseInputLines(puzzleInput()))
        }

    }

}
