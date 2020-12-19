//
//  2016Day13.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/19/20.
//

import Foundation

extension Year2016 {

    public enum Day13: PuzzleWithExample1 {

        public static let year: Year.Type = Year2016.self

        public static let day = 13

        private static func spaceIsOpen(at point: Point2D<UInt>,
                                        seed: Int) -> Bool {
            let x = point.x
            let y = point.y

            return (Int(((x * x) + (3 * x) + (2 * x * y) + y + (y * y))) + seed)
                .nonzeroBitCount
                .isMultiple(of: 2)
        }

        private static func diagram(width: UInt,
                                    height: UInt,
                                    seed: Int,
                                    path: [Point2D<UInt>] = []) -> String {
            let header = "  " + (0 ..< width)
                .map { $0 % 10 }
                .map(String.init)
                .joined()

            let body = (0 ..< height).map { y in
                "\(y % 10) " + (0 ..< width).map { x in
                    let point = Point2D(x: x, y: y)

                    if path.contains(point) {
                        return "O"
                    }
                    if spaceIsOpen(at: point, seed: seed) {
                        return "."
                    }
                    else {
                        return "#"
                    }
                }.joined()
            }

            return ([header] + body).joined(separator: "\n")
        }

        private static func shortestPath(
            from initialPoint: Point2D<UInt>,
            to destination: Point2D<UInt>,
            seed: Int
        ) -> [Point2D<UInt>] {
            var visitedPoints: Set<Point2D<UInt>> = [initialPoint]

            var paths: [[Point2D<UInt>]] = [[initialPoint]]

            while !paths.contains(where: { $0.last == destination }) {
                paths = paths.flatMap { path in
                    path.last!.directNeighbors()
                        .filter { !visitedPoints.contains($0) }
                        .filter { spaceIsOpen(at: $0, seed: seed) }
                        .map { path + [$0] }
                }

                for point in paths.compactMap({ $0.last }) {
                    visitedPoints.insert(point)
                }
            }

            return paths.first { $0.last == destination } ?? []
        }

        private static func visitablePoints(
            startingAt initialPosition: Point2D<UInt>,
            steps: Int,
            seed: Int
        ) -> Set<Point2D<UInt>> {
            var visitedPoints: Set<Point2D<UInt>> = [initialPosition]

            for _ in 0 ..< steps {
                visitedPoints.formUnion(
                    visitedPoints
                        .flatMap { $0.directNeighbors() }
                        .filter { spaceIsOpen(at: $0, seed: seed) }
                )
            }

            return visitedPoints
        }

        public static func example1() -> String {
            log(diagram(width: 10, height: 7, seed: 10))
            log("\n")

            let path = shortestPath(from: [1, 1], to: [7, 4], seed: 10)
            log(diagram(width: 10, height: 7, seed: 10, path: path))

            return "\(path.count - 1)"
        }

        public static func part1() -> String {
            let seed = parseInputLines(puzzleInput(), using: Int.init)[0]
            let path = shortestPath(from: [1, 1], to: [31, 39], seed: seed)
            return "\(path.count - 1)"
        }

        public static func part2() -> String {
            let seed = parseInputLines(puzzleInput(), using: Int.init)[0]

            let points = visitablePoints(startingAt: [1, 1],
                                         steps: 50,
                                         seed: seed)

            return "\(points.count)"
        }

    }

}
