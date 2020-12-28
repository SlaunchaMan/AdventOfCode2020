//
//  2017Day6.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/27/20.
//

import Foundation
import IsNotEmpty

private let exampleInput = "0   2   7   0"

extension Year2017 {

    public enum Day6: FullPuzzle {

        public static let year: Year.Type = Year2017.self

        public static let day = 6

        private static func banks(for input: String) -> [Int] {
            input.components(separatedBy: .whitespaces)
                .filter(\.isNotEmpty)
                .compactMap(Int.init)
        }

        private static func iterationsUntilRepeat(_ banks: [Int]) -> Int {
            var banks = banks
            var history: Set<[Int]> = []

            for iteration in 1... {
                guard let max = banks.max(),
                      var index = banks.firstIndex(of: max)
                else { preconditionFailure() }

                banks.remove(at: index)
                banks.insert(0, at: index)

                var amountLeft = max

                while amountLeft > 0 {
                    index = banks.index(after: index)
                    if index == banks.endIndex {
                        index = banks.startIndex
                    }

                    banks[index] += 1
                    amountLeft -= 1
                }

                if history.contains(banks) {
                    return iteration
                }

                history.insert(banks)
            }

            preconditionFailure()
        }

        public static func example1() -> String {
            "\(iterationsUntilRepeat(banks(for: exampleInput)))"
        }

        public static func part1() -> String {
            "\(iterationsUntilRepeat(banks(for: puzzleInput())))"
        }

        private static func iterationsBetweenRepeats(_ banks: [Int]) -> Int {
            var banks = banks
            var history: [[Int]] = []

            for iteration in 0... {
                guard let max = banks.max(),
                      var index = banks.firstIndex(of: max)
                else { preconditionFailure() }

                banks.remove(at: index)
                banks.insert(0, at: index)

                var amountLeft = max

                while amountLeft > 0 {
                    index = banks.index(after: index)
                    if index == banks.endIndex {
                        index = banks.startIndex
                    }

                    banks[index] += 1
                    amountLeft -= 1
                }

                if let firstIndex = history.firstIndex(of: banks) {
                    return iteration - firstIndex
                }

                history.append(banks)
            }

            preconditionFailure()
        }
        public static func example2() -> String {
            "\(iterationsBetweenRepeats(banks(for: exampleInput)))"
        }

        public static func part2() -> String {
            "\(iterationsBetweenRepeats(banks(for: puzzleInput())))"
        }

    }

}
