//
//  2016Day3.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/14/20.
//

import Algorithms
import Foundation

extension Year2016 {

    public enum Day3: Puzzle {

        public static let year: Year.Type = Year2016.self

        public static let day = 3

        private static func isValidTriangle(_ a: Int,
                                            _ b: Int,
                                            _ c: Int) -> Bool {
            [a, b, c].permutations().allSatisfy {
                $0[0] + $0[1] > $0[2]
            }
        }

        public static func part1() -> String {
            let input = parseInputLines(puzzleInput()) {
                $0.components(separatedBy: .whitespaces)
            }

            let numberTriples = input
                .map { $0.compactMap(Int.init) }
                .filter { $0.count == 3 }

            let validTriangles = numberTriples.filter {
                isValidTriangle($0[0], $0[1], $0[2])
            }

            return "\(validTriangles.count)"
        }

        public static func part2() -> String {
            let input = parseInputLines(puzzleInput()) {
                $0.components(separatedBy: .whitespaces)
            }

            let numberTriples = input
                .map { $0.compactMap(Int.init) }
                .filter { $0.count == 3 }

            let potentialTriangles = numberTriples.chunked(into: 3).flatMap {
                [[$0[0][0], $0[1][0], $0[2][0]],
                 [$0[0][1], $0[1][1], $0[2][1]],
                 [$0[0][2], $0[1][2], $0[2][2]]]
            }

            let validTriangles = potentialTriangles.filter {
                isValidTriangle($0[0], $0[1], $0[2])
            }

            return "\(validTriangles.count)"
        }

    }

}
