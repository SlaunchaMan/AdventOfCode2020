//
//  2020Day3.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/4/20.
//

import Foundation

private let exampleInput =
    """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """

extension Year2020 {

    public enum Day3: FullPuzzle {

        public static let year: Year.Type = Year2020.self
        public static let day: Int = 3

        static func treeCollisions(
            using input: [String],
            slope: (Int, Int) = (3, 1)
        ) -> Int {
            let width = input[0].count
            var collisions = 0

            for (row, line) in input.enumerated()
            where (row % slope.1) == 0 && !line.isEmpty {
                let col = ((row * slope.0) / slope.1) % width

                if line[line.index(line.startIndex, offsetBy: col)] == "#" {
                    collisions += 1
                }
            }

            return collisions
        }

        public static func example1() -> String {
            return "\(treeCollisions(using: parseInputLines(exampleInput)))"
        }

        public static func part1() -> String {
            return "\(treeCollisions(using: parseInputLines(puzzleInput())))"
        }

        public static func example2() -> String {
            let input = parseInputLines(exampleInput)

            let collisions = [
                treeCollisions(using: input, slope: (1, 1)),
                treeCollisions(using: input, slope: (3, 1)),
                treeCollisions(using: input, slope: (5, 1)),
                treeCollisions(using: input, slope: (7, 1)),
                treeCollisions(using: input, slope: (1, 2))
            ]

            return "\(collisions.reduce(1, *))"
        }

        public static func part2() -> String {
            let input = parseInputLines(puzzleInput())
            let collisions =
                [treeCollisions(using: input, slope: (1, 1)),
                 treeCollisions(using: input, slope: (3, 1)),
                 treeCollisions(using: input, slope: (5, 1)),
                 treeCollisions(using: input, slope: (7, 1)),
                 treeCollisions(using: input, slope: (1, 2))]

            return "\(collisions.reduce(1, *))"
        }

    }

}
