//
//  2016Day16.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/22/20.
//

import Foundation

extension Year2016 {

    public enum Day16: PuzzleWithExample1 {

        public static let year: Year.Type = Year2016.self

        public static let day = 16

        private static func dragonCurvePad(input: [Bool],
                                           to length: Int) -> [Bool] {
            var state = input

            while state.count < length {
                let b = state.map { !$0 }.reversed()
                state.append(false)
                state.append(contentsOf: b)
            }

            return Array(state.prefix(length))
        }

        private static func checksum(for input: [Bool]) -> String {
            var state = input

            while state.count.isMultiple(of: 2) {
                state = state.chunked(into: 2).map {
                    switch ($0[0], $0[1]) {
                    case (true, true), (false, false): return true
                    default: return false
                    }
                }
            }

            return state.map { $0 ? "1" : "0" }.joined()
        }

        public static func example1() -> String {
            let input = "10000".map { $0 == "1" }
            return checksum(for: dragonCurvePad(input: input, to: 20))
        }

        public static func part1() -> String {
            let input = puzzleInput().map { $0 == "1" }
            return checksum(for: dragonCurvePad(input: input, to: 272))
        }

        public static func part2() -> String {
            let input = puzzleInput().map { $0 == "1" }
            return checksum(for: dragonCurvePad(input: input, to: 35651584))
        }

    }

}
