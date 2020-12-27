//
//  2015Day1.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation

extension Year2015 {

    public enum Day1: TwoPartPuzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 1

        public static func part1() -> String {
            let input = puzzleInput()

            let destination = input.reduce(into: 0) { floor, character in
                switch character {
                case "(": floor += 1
                case ")": floor -= 1
                default: break
                }
            }

            return "\(destination)"
        }

        public static func part2() -> String {
            let input = puzzleInput()

            var floor = 0

            for (index, character) in input.enumerated() {
                switch character {
                case "(": floor += 1
                case ")": floor -= 1
                default: break
                }

                if floor < 0 {
                    return "\(index + 1)"
                }
            }

            return ""
        }

    }

}
