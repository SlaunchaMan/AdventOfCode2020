//
//  2016Day18.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/22/20.
//

import Foundation

extension Year2016 {

    public enum Day18: PuzzleWithExample1 {

        public static let year: Year.Type = Year2016.self

        public static let day = 18

        private static func row(after row: String) -> String {
            let elements = Array(row)
            let length = elements.count
            var result = ""

            for i in 0 ..< length {
                let leftTrapped = (i > 0) && (elements[i - 1]) == "^"
                let centerTrapped = (elements[i] == "^")
                let rightTrapped = (i + 1 < length) && (elements[i + 1] == "^")

                switch (leftTrapped, centerTrapped, rightTrapped) {
                case (true, true, false),
                     (false, true, true),
                     (true, false, false),
                     (false, false, true):
                    result.append("^")
                default:
                    result.append(".")
                }
            }

            return result
        }

        public static func example1() -> String {
            var lines: [String] = [".^^.^.^^^^"]

            while lines.count < 10 {
                lines.append(row(after: lines.last!))
            }

            return "\(lines.sum { $0.count(of: ".") })"
        }

        public static func part1() -> String {
            var lines: [String] = [puzzleInput()]

            while lines.count < 40 {
                lines.append(row(after: lines.last!))
            }

            return "\(lines.sum { $0.count(of: ".") })"
        }

        public static func part2() -> String {
            var lines: [String] = [puzzleInput()]

            while lines.count < 400_000 {
                lines.append(row(after: lines.last!))
            }

            return "\(lines.sum { $0.count(of: ".") })"
        }

    }

}
