//
//  2016Day24.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/27/20.
//

import Algorithms
import Foundation

private let exampleInput =
    """
    ###########
    #0.1.....2#
    #.#######.#
    #4.......3#
    ###########
    """

extension Year2016 {

    public enum Day24: TwoPartPuzzleWithExample1 {

        public static let year: Year.Type = Year2016.self

        public static let day = 24

        typealias Maze = [[Character]]

        struct MazeState: CustomStringConvertible, Hashable {
            let maze: Maze
            let collectedNumbers: Set<Int>
            let position: Maze.Position

            var description: String {
                maze.indexed().map { outerIndex, row in
                    row.indexed().map { innerIndex, character in
                        if (outerIndex, innerIndex) == position {
                            return "(\(character))"
                        }
                        else if character.isNumber {
                            guard let intValue = Int(String(character))
                            else { preconditionFailure() }

                            if collectedNumbers.contains(intValue) {
                                return "[\(intValue)]"
                            }
                            else {
                                return " \(intValue) "
                            }
                        }
                        else {
                            return " \(character) "
                        }
                    }.joined()
                }.joined(separator: "\n")
            }

            static func == (lhs: MazeState, rhs: MazeState) -> Bool {
                lhs.collectedNumbers == rhs.collectedNumbers &&
                    lhs.position.outerIndex == rhs.position.outerIndex &&
                    lhs.position.innerIndex == rhs.position.innerIndex
            }

            func hash(into hasher: inout Hasher) {
                hasher.combine(collectedNumbers)
                hasher.combine(position.outerIndex)
                hasher.combine(position.innerIndex)
            }

            func nextValidStates() -> Set<MazeState> {
                var validStates: Set<MazeState> = []

                for neighbor in maze.directNeighbors(of: position)
                where maze[neighbor.outerIndex][neighbor.innerIndex] != "#" {
                    var collectedNumbers = self.collectedNumbers

                    let item = maze[neighbor.outerIndex][neighbor.innerIndex]

                    if item.isNumber, let number = Int(String(item)) {
                        collectedNumbers.insert(number)
                    }

                    validStates.insert(
                        MazeState(
                            maze: maze,
                            collectedNumbers: collectedNumbers,
                            position: neighbor
                        )
                    )
                }

                return validStates
            }
        }

        private static func maze(from input: String) -> Maze {
            parseInputLines(input, using: Array.init)
        }

        private static func shortestPath(
            through maze: Maze,
            returningToStart returning: Bool = false
        ) -> Int {
            guard let startingPosition = maze.firstPosition(of: "0")
            else { preconditionFailure() }

            let allNumbers = Set(maze.flatMap { $0 }
                                    .filter { $0.isNumber }
                                    .map(String.init)
                                    .compactMap(Int.init))

            let state = MazeState(maze: maze,
                                  collectedNumbers: [0],
                                  position: startingPosition)

            var previousStates: Set<MazeState> = [state]
            var currentStates: Set<MazeState> = [state]

            for i in 1... {
                var nextStates: Set<MazeState> = []

                for state in currentStates {
                    for nextState in state.nextValidStates() {
                        if !previousStates.contains(nextState) {
                            nextStates.insert(nextState)
                        }
                    }
                }

                for nextState in nextStates {
                    if nextState.collectedNumbers == allNumbers,
                       (!returning || nextState.position == startingPosition) {
                        return i
                    }
                }

                previousStates.formUnion(nextStates)
                currentStates = nextStates
            }

            preconditionFailure()
        }

        public static func example1() -> String {
            "\(shortestPath(through: maze(from: exampleInput)))"
        }

        public static func part1() -> String {
            "\(shortestPath(through: maze(from: puzzleInput())))"
        }

        public static func part2() -> String {
            let path = shortestPath(through: maze(from: puzzleInput()),
                                    returningToStart: true)
            return "\(path)"
        }

    }

}
