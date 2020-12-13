//
//  2015Day20.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/11/20.
//

import Foundation

extension Year2015 {

    public enum Day20: PuzzleWithExample1 {

        public static let year: Year.Type = Year2015.self

        public static let day = 20

        private static func presentsPart1(atHouse houseNumber: Int) -> Int {
            return houseNumber
                .factors()
                .map { $0 * 10 }
                .sum()
        }

        private static func presentsPart2(atHouse houseNumber: Int) -> Int {
            return houseNumber
                .factors(startingAt: houseNumber / 50)
                .map { $0 * 11 }
                .sum()
        }

        public static func example1() -> String {
            (1...9)
                .map(presentsPart1(atHouse:))
                .enumerated()
                .map { (index, presents) in
                    return "House \(index + 1) got \(presents) presents."
                }
                .joined(separator: "\n")
        }

        public static func part1() -> String {
            guard let target = Int(puzzleInput()) else { fatalError() }
            let house = (1...).leastConcurrent {
                let presents = presentsPart1(atHouse: $0)
                log("House \($0) got \(presents) presents.")
                return presents >= target
            }
            return "\(house!)"
        }

        public static func part2() -> String {
            guard let target = Int(puzzleInput()) else { fatalError() }
            let house = (1...).leastConcurrent {
                let presents = presentsPart2(atHouse: $0)
                log("House \($0) got \(presents) presents.")
                return presents >= target
            }
            return "\(house!)"
        }

    }

}
