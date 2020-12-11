//
//  2020Day11.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/10/20.
//

import Foundation

private let exampleInput =
    """
    L.LL.LL.LL
    LLLLLLL.LL
    L.L.L..L..
    LLLL.LL.LL
    L.LL.LL.LL
    L.LLLLL.LL
    ..L.L.....
    LLLLLLLLLL
    L.LLLLLL.L
    L.LLLLL.LL
    """

extension Year2020 {

    public enum Day11: FullPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 11

        private static func nextStatePart1(for state: [String]) -> [String] {
            var nextState = state

            for (outerIndex, line) in state.indexed() {
                for (innerIndex, _) in line.indexed() {
                    let position = (outerIndex, innerIndex)
                    let neighbors = state.neighbors(of: position)

                    let occupiedNeighbors = neighbors.count { neighborPos in
                        state[neighborPos] == "#"
                    }

                    switch (state[position], occupiedNeighbors) {
                    case ("L", 0):
                        nextState[position] = "#"

                    case ("#", 4...):
                        nextState[position] = "L"

                    default:
                        break
                    }
                }
            }

            return nextState
        }

        private static func stableSeatsPart1(
            initialState: [String]
        ) -> Int {
            var state = initialState

            for _ in 1... {
                let nextState = nextStatePart1(for: state)

                if state == nextState {
                    return state.sum { $0.count(where: { $0 == "#" }) }
                }

                state = nextState
            }

            return 0
        }

        public static func example1() -> String {
            "\(stableSeatsPart1(initialState: parseInputLines(exampleInput)))"
        }

        public static func part1() -> String {
            "\(stableSeatsPart1(initialState: parseInputLines(puzzleInput())))"
        }

        private static func nextStatePart2(for state: [String]) -> [String] {
            var nextState = state

            for (outerIndex, line) in state.indexed() {
                for (innerIndex, _) in line.indexed() {
                    let position = (outerIndex, innerIndex)
                    let neighbors = state.firstVisibleNeighbors(
                        of: position,
                        skippingIndexesWhere: { $0 == "." }
                    )

                    let occupiedNeighbors = neighbors.count { neighborPos in
                        state[neighborPos] == "#"
                    }

                    switch (state[position], occupiedNeighbors) {
                    case ("L", 0):
                        nextState[position] = "#"

                    case ("#", 5...):
                        nextState[position] = "L"

                    default:
                        break
                    }
                }
            }

            return nextState
        }

        private static func stableSeatsPart2(
            initialState: [String]
        ) -> Int {
            var state = initialState

            for _ in 1... {
                let nextState = nextStatePart2(for: state)

                if state == nextState {
                    return state.sum { $0.count(where: { $0 == "#" }) }
                }

                state = nextState
            }

            return 0
        }

        public static func example2() -> String {
            "\(stableSeatsPart2(initialState: parseInputLines(exampleInput)))"
        }

        public static func part2() -> String {
            "\(stableSeatsPart2(initialState: parseInputLines(puzzleInput())))"
        }

    }

}
