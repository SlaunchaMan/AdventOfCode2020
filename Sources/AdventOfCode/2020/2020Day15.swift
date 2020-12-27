//
//  2020Day15.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/15/20.
//

import Foundation

private let exampleInput = "0,3,6"

extension Year2020 {

    public enum Day15: TwoPartPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 15

        private static func spokenNumber(at finalIndex: Int,
                                         startingNumbers: [Int]) -> Int {
            var history: [Int: (Int, Int?)] = [:]

            func addToHistory(number: Int, atIndex index: Int) {
                history[number] = (index, history[number]?.0)
            }

            func lastTwoIndexes(for number: Int) -> (Int, Int)? {
                guard let indexes = history[number],
                      let firstIndex = indexes.1
                else { return nil }

                return (indexes.0, firstIndex)
            }

            for (index, number) in startingNumbers.enumerated() {
                addToHistory(number: number, atIndex: index)
            }

            var lastNumber = startingNumbers.last!

            for index in startingNumbers.count ..< finalIndex {
                if let history = lastTwoIndexes(for: lastNumber) {
                    lastNumber = history.0 - history.1
                }
                else {
                    lastNumber = 0
                }

                addToHistory(number: lastNumber, atIndex: index)
            }

            return lastNumber
        }

        public static func example1() -> String {
            let startingNumbers = exampleInput
                .components(separatedBy: ",")
                .compactMap(Int.init)

            return "\(spokenNumber(at: 2020, startingNumbers: startingNumbers))"
        }

        public static func part1() -> String {
            let startingNumbers = puzzleInput()
                .components(separatedBy: ",")
                .compactMap(Int.init)

            return "\(spokenNumber(at: 2020, startingNumbers: startingNumbers))"
        }

        public static func example2() -> String {
            let startingNumbers = exampleInput
                .components(separatedBy: ",")
                .compactMap(Int.init)

            let answer = spokenNumber(at: 30000000,
                                      startingNumbers: startingNumbers)

            return "\(answer)"
        }

        public static func part2() -> String {
            let startingNumbers = puzzleInput()
                .components(separatedBy: ",")
                .compactMap(Int.init)

            let answer = spokenNumber(at: 30000000,
                                      startingNumbers: startingNumbers)

            return "\(answer)"
        }

    }

}
