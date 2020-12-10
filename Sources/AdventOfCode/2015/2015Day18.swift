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

        private static func iterate(
            lights: [String],
            iterations: Int,
            alwaysEnabledIndexes: [(Array<String>.Index, String.Index)] = []
        ) -> [String] {
            var state = lights

            for position in alwaysEnabledIndexes {
                state[position] = "#"
            }

            for _ in 0 ..< iterations {
                var nextState = state

                for (outerIndex, line) in state.indexed() {
                    for (innerIndex, _) in line.indexed() {
                        let position = (outerIndex, innerIndex)
                        let neighbors = state.neighbors(of: position)

                        let livingNeighbors = neighbors.count { neighborPos in
                            state[neighborPos] == "#"
                        }

                        switch (state[position], livingNeighbors) {
                        case (_, 3), ("#", 2):
                            nextState[position] = "#"

                        default:
                            nextState[position] = "."
                        }
                    }
                }

                for position in alwaysEnabledIndexes {
                    nextState[position] = "#"
                }

                state = nextState
            }

            return state
        }

        public static func example1() -> String {
            let lights: [String] = parseInputLines(exampleInput)
            let finalState = iterate(lights: lights, iterations: 5)
            return String(finalState.joined(separator: "\n").count(of: "#"))
        }

        public static func part1() -> String {
            let lights: [String] = parseInputLines(puzzleInput())
            let finalState = iterate(lights: lights, iterations: 100)
            return String(finalState.joined(separator: "\n").count(of: "#"))
        }

        public static func example2() -> String {
            let lights: [String] = parseInputLines(exampleInput)

            let finalState = iterate(
                lights: lights,
                iterations: 5,
                alwaysEnabledIndexes: lights.cornerIndexes
            )

            return String(finalState.joined(separator: "\n").count(of: "#"))
        }

        public static func part2() -> String {
            let lights: [String] = parseInputLines(puzzleInput())

            let finalState = iterate(
                lights: lights,
                iterations: 100,
                alwaysEnabledIndexes: lights.cornerIndexes
            )

            return String(finalState.joined(separator: "\n").count(of: "#"))
        }

    }

}
