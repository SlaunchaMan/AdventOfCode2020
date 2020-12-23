//
//  2016Day20.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/23/20.
//

import Foundation

private let exampleInput =
    """
    5-8
    0-2
    4-7
    """

extension Year2016 {

    public enum Day20: PuzzleWithExample1 {

        public static let year: Year.Type = Year2016.self

        public static let day = 20

        static func range(
            from input: String
        ) -> BinaryIntegerSet<UInt32>.Range? {
            let components = input.components(separatedBy: "-")
                .compactMap(UInt32.init)

            guard components.count == 2 else { return nil }

            return .init(lowerBound: components[0], upperBound: components[1])
        }

        public static func example1() -> String {
            let ranges = parseInputLines(exampleInput, using: range(from:))
            let set = BinaryIntegerSet(ranges)

            let valid = (UInt32(0)...9).filter { candidate in
                !set.contains(candidate)
            }

            return "\(valid.map(String.init).joined(separator: ", "))"
        }

        private static func lowestIDAllowed(
            using blocklist: BinaryIntegerSet<UInt32>
        ) -> UInt32? {
            (UInt32.min ... UInt32.max).first { candidate in
                !blocklist.contains(candidate)
            }
        }

        public static func part1() -> String {
            let ranges = parseInputLines(puzzleInput(), using: range(from:))
            let set = BinaryIntegerSet(ranges)

            return "\(lowestIDAllowed(using: set)!)"
        }

        public static func part2() -> String {
            let ranges = parseInputLines(puzzleInput(), using: range(from:))
            let set = BinaryIntegerSet(ranges)

            let fullRange = BinaryIntegerSet(lowerBound: UInt32.min,
                                             upperBound: UInt32.max)

            return "\(fullRange.count - set.count + 1)"
        }

    }

}
