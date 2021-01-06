//
//  2017Day10.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 01/5/21.
//

import Algorithms
import Foundation

extension MutableCollection where Index == Int {

    mutating func circularReverse(startingAt lowerOffset: Int, length: Int) {
        var lowIndex = lowerOffset
        var highIndex = lowerOffset + length - 1

        while highIndex > lowIndex {
            swapAt(lowIndex % count, highIndex % count)
            lowIndex += 1
            highIndex -= 1
        }
    }

}

extension Year2017 {

    public enum Day10: FullPuzzle {

        public static let year: Year.Type = Year2017.self

        public static let day = 10

        private static func knotHash(list: [Int],
                                     lengths: [Int],
                                     rounds: Int = 1) -> [Int] {
            var list = list
            var skipSize = 0
            var index = 0

            for _ in 0 ..< rounds {
                for length in lengths {
                    list.circularReverse(startingAt: index, length: length)
                    index += skipSize + length
                    skipSize += 1
                }
            }

            return list
        }

        public static func example1() -> String {
            let hashedList = knotHash(list: Array(0...4), lengths: [3, 4, 1, 5])

            return "\(hashedList[0] * hashedList[1])"
        }

        public static func part1() -> String {
            let lengths = puzzleInput()
                .components(separatedBy: ",")
                .compactMap(Int.init)

            let hashedList = knotHash(list: Array(0...255), lengths: lengths)

            return "\(hashedList[0] * hashedList[1])"
        }

        private static func denseHash(for sparseHash: [Int]) -> [Int] {
            sparseHash.chunked(into: 16).map { chunk in
                chunk.reduce(0, ^)
            }
        }

        private static func knotHashString(_ input: String) -> String {
            let lengths = input.compactMap(\.asciiValue) + [17, 31, 73, 47, 23]

            let sparseHash = knotHash(list: Array(0...255),
                                      lengths: lengths.map(Int.init),
                                      rounds: 64)

            let denseHash = self.denseHash(for: sparseHash)

            return denseHash.map { String.init(format: "%02x", $0) }.joined()
        }

        public static func example2() -> String {
            ["", "AoC 2017", "1,2,3", "1,2,4"]
                .map(knotHashString)
                .joined(separator: "\n")
        }

        public static func part2() -> String {
            knotHashString(puzzleInput())
        }

    }

}
