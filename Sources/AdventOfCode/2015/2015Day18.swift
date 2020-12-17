//
//  2015Day18.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/9/20.
//

import Foundation

private let exampleInput =
    """
    .#.#.#
    ...##.
    #....#
    ..#...
    #.#..#
    ####..
    """

extension Year2015 {

    public enum Day18: FullPuzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 18

        private static func initialState(
            from strings: [String]
        ) -> Set<Point2D<Int>> {
            var initialEnabledPoints = Set<Point2D<Int>>()

            for (y, row) in strings.enumerated() {
                for (x, value) in row.enumerated() where value == "#" {
                    initialEnabledPoints.insert(Point2D(x: x, y: y))
                }
            }

            return initialEnabledPoints
        }

        public static func example1() -> String {
            let lights = initialState(from: parseInputLines(exampleInput))
            var game = BoundedGameOfLife(
                initialState: lights,
                bounds: PointBounds2D(
                    validX: 0 ..< 6,
                    validY: 0 ..< 6
                )
            )

            for _ in 0 ..< 4 {
                game = game.nextState()
            }

            return "\(game.state.count)"
        }

        public static func part1() -> String {
            let lights = initialState(from: parseInputLines(puzzleInput()))
            var game = BoundedGameOfLife(
                initialState: lights,
                bounds: PointBounds2D(
                    validX: 0 ..< 100,
                    validY: 0 ..< 100
                )
            )

            for _ in 0 ..< 100 {
                game = game.nextState()
            }

            return "\(game.state.count)"
        }

        public static func example2() -> String {
            let lights = initialState(from: parseInputLines(exampleInput))
            var game = BoundedGameOfLife(
                initialState: lights,
                bounds: PointBounds2D(
                    validX: 0 ..< 6,
                    validY: 0 ..< 6
                ),
                alwaysEnabledPoints: [[0, 0], [0, 5], [5, 0], [5, 5]]
            )

            for _ in 0 ..< 5 {
                game = game.nextState()
            }

            return "\(game.state.count)"
        }

        public static func part2() -> String {
            let lights = initialState(from: parseInputLines(puzzleInput()))
            var game = BoundedGameOfLife(
                initialState: lights,
                bounds: PointBounds2D(
                    validX: 0 ..< 100,
                    validY: 0 ..< 100
                ),
                alwaysEnabledPoints: [[0, 0], [0, 99], [99, 0], [99, 99]]
            )

            for _ in 0 ..< 100 {
                game = game.nextState()
            }

            return "\(game.state.count)"
        }

    }

}
