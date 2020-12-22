//
//  2020Day9.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/8/20.
//

import Algorithms
import Foundation
import IsNotEmpty

private let exampleInput =
    """
    35
    20
    15
    25
    47
    40
    62
    55
    65
    95
    102
    117
    150
    182
    127
    219
    299
    277
    309
    576
    """

extension Year2020 {

    public enum Day9: FullPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 9

        private static func firstInvalidNumber(in numbers: [Int],
                                               preambleLength: Int) -> Int? {
            var buffer: [Int] = Array(numbers[0..<preambleLength])
            var remainder = numbers.dropFirst(preambleLength)

            repeat {
                let next = remainder.removeFirst()

                guard buffer
                        .combinations(ofCount: 2)
                        .contains(where: { $0.sum() == next })
                else { return next }

                buffer.removeFirst()
                buffer.append(next)
            } while remainder.isNotEmpty

            return nil
        }

        public static func example1() -> String {
            let numbers = parseInputLines(exampleInput, using: Int.init)

            let firstInvalid = firstInvalidNumber(in: numbers,
                                                  preambleLength: 5)

            return "\(firstInvalid!)"
        }

        public static func part1() -> String {
            let numbers = parseInputLines(puzzleInput(), using: Int.init)

            let firstInvalid = firstInvalidNumber(in: numbers,
                                                  preambleLength: 25)

            return "\(firstInvalid!)"

        }

        private static func encryptionWeakness(in numbers: [Int],
                                               preambleLength: Int) -> Int? {
            guard let firstInvalid = firstInvalidNumber(
                    in: numbers,
                    preambleLength: preambleLength
            ) else { return nil }

            for startIndex in 0 ..< numbers.count {
                var endIndex = numbers.index(after: startIndex)

                while numbers[startIndex ... endIndex].sum() < firstInvalid {
                    guard endIndex < numbers.lastIndex
                    else { break }

                    endIndex = numbers.index(after: endIndex)
                }

                let candidate = numbers[startIndex ... endIndex]

                if candidate.sum() == firstInvalid,
                   let min = candidate.min(),
                   let max = candidate.max() {
                    return min + max
                }
            }

            return nil
        }

        public static func example2() -> String {
            let numbers = parseInputLines(exampleInput, using: Int.init)

            return "\(encryptionWeakness(in: numbers, preambleLength: 5)!)"
        }

        public static func part2() -> String {
            let numbers = parseInputLines(puzzleInput(), using: Int.init)

            return "\(encryptionWeakness(in: numbers, preambleLength: 25)!)"
        }

    }

}
