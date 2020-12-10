//
//  2020Day10.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/9/20.
//

import Algorithms
import Foundation

private let exampleInput =
    """
    16
    10
    15
    5
    1
    11
    7
    19
    6
    12
    4
    """

private let exampleInput2 =
    """
    28
    33
    18
    42
    31
    14
    46
    20
    48
    47
    24
    23
    49
    45
    19
    38
    39
    11
    1
    32
    25
    35
    8
    17
    7
    9
    4
    2
    34
    10
    3
    """

extension Year2020 {

    public enum Day10: FullPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 10

        private static func parseAdapters(from input: String) -> [Int] {
            var adapters = parseInputLines(input, using: Int.init)
            adapters.insert(0, at: adapters.startIndex)
            adapters.insert(adapters.max()! + 3, at: adapters.endIndex)
            return adapters
        }

        private static func computeDifferences(for adapters: [Int]) -> Int {
            var iterator = adapters.sorted().makeIterator()
            var diffOfOne = 0
            var diffOfThree = 0

            var first = 0
            while let next = iterator.next() {
                switch next - first {
                case 3: diffOfThree += 1
                case 1: diffOfOne += 1
                default: break
                }

                first = next
            }

            return diffOfOne * diffOfThree
        }

        public static func example1() -> String {
            let adapters = parseAdapters(from: exampleInput)
            return "\(computeDifferences(for: adapters))"
        }

        public static func example1Part2() -> String {
            let adapters = parseAdapters(from: exampleInput2)
            return "\(computeDifferences(for: adapters))"
        }

        public static func part1() -> String {
            let adapters = parseAdapters(from: puzzleInput())
            return "\(computeDifferences(for: adapters))"
        }

        private static func previousPossibleAdapters(
            in adapters: [Int],
            satisfying joltage: Int
        ) -> [Int] {
            adapters.filter {
                switch joltage - $0 {
                case 1...3: return true
                default: return false
                }
            }
        }

        private static func numberOfPaths(through adapters: [Int]) -> Int {
            var paths = [Int](repeating: 0, count: adapters.count)
            paths[0] = 1

            let adapters = adapters.sorted()

            for (index, nextAdapter) in adapters.enumerated() {
                for path in previousPossibleAdapters(in: adapters,
                                                     satisfying: nextAdapter) {
                    if let sourceIndex = adapters.firstIndex(of: path) {
                        paths[index] += paths[sourceIndex]
                    }
                }
            }

            return paths.last!
        }

        public static func example2() -> String {
            let adapters = parseAdapters(from: exampleInput)
            let pathCount = numberOfPaths(through: adapters)
            return "\(pathCount)"
        }

        public static func example2Part2() -> String {
            let adapters = parseAdapters(from: exampleInput2)
            let pathCount = numberOfPaths(through: adapters)
            return "\(pathCount)"
        }

        public static func part2() -> String {
            let adapters = parseAdapters(from: puzzleInput())
            let pathCount = numberOfPaths(through: adapters)
            return "\(pathCount)"
        }

    }

}
