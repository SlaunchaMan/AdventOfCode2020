//
//  2020Day17.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/17/20.
//

import Algorithms
import Foundation

private let exampleInput =
    """
    .#.
    ..#
    ###
    """

extension Year2020 {

    public enum Day17: FullPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 17

        private static func initialDimension<T: NDimensionPoint>(
            from slice: [[Bool]]
        ) -> Set<T> where T.Unit == Int {
            var initialEnabledPoints = Set<T>()

            for (y, row) in slice.indexed() {
                for (x, value) in row.indexed() where value == true {
                    initialEnabledPoints.insert(T(x: x, y: y))
                }
            }

            return initialEnabledPoints
        }

        private static func description(
            of dimension: Set<Point3D<Int>>
        ) -> String {
            guard let minZ = dimension.map(\.z).min(),
                  let maxZ = dimension.map(\.z).max(),
                  let minY = dimension.map(\.y).min(),
                  let maxY = dimension.map(\.y).max(),
                  let minX = dimension.map(\.x).min(),
                  let maxX = dimension.map(\.x).max()
            else { fatalError() }

            return (minZ...maxZ).map { z in
                "z=\(z):\n" + (minY...maxY).map { y in
                    (minX...maxX).map { x in
                        let point = Point3D(x: x, y: y, z: z)

                        return dimension.contains(point) ? "#" : "."
                    }.joined()
                }.joined(separator: "\n")
            }.joined(separator: "\n\n")
        }

        public static func example1() -> String {
            let slice = parseInputLines(exampleInput) {
                $0.map { $0 == "#" ? true : false }
            }

            var game = GameOfLife<Point3D>(
                initialState: initialDimension(from: slice)
            )

            log("Before any cycles:\n")
            log(description(of: game.state))
            log("\n")

            for cycle in 1 ... 6 {
                game = game.nextState()

                if cycle <= 3 {
                    log("After \(cycle) cycle\(cycle > 1 ? "s" : ""):\n")
                    log(description(of: game.state))
                    log("\n\n")
                }
            }

            return "\(game.state.count)"
        }

        public static func part1() -> String {
            let slice = parseInputLines(puzzleInput()) {
                $0.map { $0 == "#" ? true : false }
            }

            var game = GameOfLife<Point3D>(
                initialState: initialDimension(from: slice)
            )

            for _ in 0 ..< 6 {
                game = game.nextState()
            }

            return "\(game.state.count)"
        }

        static func description(of dimension: Set<Point4D<Int>>) -> String {
            guard let minZ = dimension.map(\.z).min(),
                  let maxZ = dimension.map(\.z).max(),
                  let minY = dimension.map(\.y).min(),
                  let maxY = dimension.map(\.y).max(),
                  let minX = dimension.map(\.x).min(),
                  let maxX = dimension.map(\.x).max(),
                  let minW = dimension.map(\.w).min(),
                  let maxW = dimension.map(\.w).max()
            else { fatalError() }

            return (minW...maxW).map { w in
                (minZ...maxZ).map { z in
                    "z=\(z), w=\(w):\n" + (minY...maxY).map { y in
                        (minX...maxX).map { x in
                            let point = Point4D(x: x, y: y, z: z, w: w)

                            return dimension.contains(point) ? "#" : "."
                        }.joined()
                    }.joined(separator: "\n")
                }.joined(separator: "\n\n")
            }.joined(separator: "\n\n")
        }

        public static func example2() -> String {
            let slice = parseInputLines(exampleInput) {
                $0.map { $0 == "#" ? true : false }
            }

            var game = GameOfLife<Point4D>(
                initialState: initialDimension(from: slice)
            )

            log("Before any cycles:\n")
            log(description(of: game.state))
            log("\n")

            for cycle in 1 ... 6 {
                game = game.nextState()

                if cycle <= 2 {
                    log("After \(cycle) cycle\(cycle > 1 ? "s" : ""):\n")
                    log(description(of: game.state))
                    log("\n\n")
                }
            }

            return "\(game.state.count)"
        }

        public static func part2() -> String {
            let slice = parseInputLines(puzzleInput()) {
                $0.map { $0 == "#" ? true : false }
            }

            var game = GameOfLife<Point4D>(
                initialState: initialDimension(from: slice)
            )

            for _ in 0 ..< 6 {
                game = game.nextState()
            }

            return "\(game.state.count)"
        }

    }

}
