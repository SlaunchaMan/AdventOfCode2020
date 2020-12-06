//
//  2020Day6.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/6/20.
//

import Foundation

private let exampleInput =
    """
    abc

    a
    b
    c

    ab
    ac

    a
    a
    a
    a

    b
    """

extension Year2020 {

    public enum Day6: FullPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 6

        private static func groupCountsPart1(input: String) -> Int {
            input.components(separatedBy: "\n\n").map {
                $0.components(separatedBy: .newlines).map {
                    Set($0)
                }
                .reduce(into: Set<Character>()) { $0.formUnion(Set($1)) }
            }
            .sum(\.count)
        }

        public static func example1() -> String {
            return "\(groupCountsPart1(input: exampleInput))"
        }

        public static func part1() -> String {
            return "\(groupCountsPart1(input: puzzleInput()))"
        }

        private static func groupCountsPart2(input: String) -> Int {
            input
                .components(separatedBy: "\n\n")
                .map { (groups: String) -> Set<Character> in
                    let answers = groups
                        .components(separatedBy: .newlines)
                        .map(Set.init)

                    var iterator = answers.makeIterator()

                    var allAnswered = iterator.next()!

                    while let next = iterator.next() {
                        allAnswered.formIntersection(next)
                    }
                    return allAnswered
                }
                .sum(\.count)
        }

        public static func example2() -> String {
            return "\(groupCountsPart2(input: exampleInput))"
        }

        public static func part2() -> String {
            return "\(groupCountsPart2(input: puzzleInput()))"
        }

    }

}
