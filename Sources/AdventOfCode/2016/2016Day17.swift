//
//  2016Day17.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/22/20.
//

import Crypto
import Foundation

extension Year2016 {

    public enum Day17: FullPuzzle {

        public static let year: Year.Type = Year2016.self

        public static let day = 17

        struct State: CustomStringConvertible, Hashable {
            let position: Point2D<Int>
            let path: [MovementDirection]

            var description: String {
                "\(position.description): \(Day17.string(for: path))"
            }

            private func hashSeed(password: String) -> String {
                password + Day17.string(for: path)
            }

            private func openDirectionsBasedOnHash(
                _ password: String
            ) -> Set<MovementDirection> {
                let hashSeed = self.hashSeed(password: password)
                let computedHash = Insecure.MD5.hash(
                    data: Data(hashSeed.utf8)
                ).stringValue

                log("\(hashSeed) => \(computedHash)")

                var hash = computedHash.prefix(4)

                var openDirectionsBasedOnHash: Set<MovementDirection> = []

                for direction in MovementDirection.allCases {
                    if ["b", "c", "d", "e", "f"].contains(hash.removeFirst()) {
                        openDirectionsBasedOnHash.insert(direction)
                    }
                }

                return openDirectionsBasedOnHash
            }

            private func openDirectionsBasedOnPosition(
            ) -> Set<MovementDirection> {
                var openDirectionsBasedOnPosition: Set<MovementDirection> = []

                if position.x > 0 {
                    openDirectionsBasedOnPosition.insert(.left)
                }

                if position.x < 3 {
                    openDirectionsBasedOnPosition.insert(.right)
                }

                if position.y > 0 {
                    openDirectionsBasedOnPosition.insert(.down)
                }

                if position.y < 3 {
                    openDirectionsBasedOnPosition.insert(.up)
                }

                return openDirectionsBasedOnPosition
            }

            func validMovementDirections(
                password: String
            ) -> Set<MovementDirection> {
                openDirectionsBasedOnHash(password)
                    .intersection(openDirectionsBasedOnPosition())
            }

            func nextPossibleStates(password: String) -> Set<State> {
                Set(validMovementDirections(password: password).map {
                    State(position: position + $0, path: path + [$0])
                })
            }
        }

        private static func string(for path: [MovementDirection]) -> String {
            path
                .compactMap { $0.rawValue.uppercased().first }
                .map(String.init)
                .joined()
        }

        private static func shortestPath(
            from startPoint: Point2D<Int>,
            to endPoint: Point2D<Int>,
            password: String
        ) -> [MovementDirection] {
            var states: Set<State> = [State(position: startPoint, path: [])]

            while states.isNotEmpty,
                  !states.contains(where: { $0.position == endPoint }) {
                states = Set(states.flatMap {
                    $0.nextPossibleStates(password: password)
                })
            }

            return states.first { $0.position == endPoint }!.path
        }

        public static func example1() -> String {
            ["ihgpwlah", "kglvqrro", "ulqzkmiv"].map {
                shortestPath(from: [0, 3], to: [3, 0], password: $0)
            }
            .map {
                string(for: $0)
            }
            .joined(separator: ",")
        }

        public static func part1() -> String {
            string(for: shortestPath(from: [0, 3],
                                     to: [3, 0],
                                     password: puzzleInput()))
        }

        private static func longestPath(
            from startPoint: Point2D<Int>,
            to endPoint: Point2D<Int>,
            password: String
        ) -> Int {
            var states: Set<State> = [State(position: startPoint, path: [])]
            var longest = 0

            while states.isNotEmpty {
                states = Set(states.flatMap {
                    $0.nextPossibleStates(password: password)
                })

                let unfinishedStates = states.filter { $0.position != endPoint }
                let finishedStates = states.filter { $0.position == endPoint }

                if let longestPath = finishedStates.map(\.path.count).max() {
                    longest = max(longest, longestPath)
                }

                states = unfinishedStates
            }

            return longest
        }

        public static func example2() -> String {
            ["ihgpwlah", "kglvqrro", "ulqzkmiv"].map {
                longestPath(from: [0, 3], to: [3, 0], password: $0)
            }
            .map(String.init)
            .joined(separator: ",")
        }

        public static func part2() -> String {
            "\(longestPath(from: [0, 3], to: [3, 0], password: puzzleInput()))"
        }

    }

}
