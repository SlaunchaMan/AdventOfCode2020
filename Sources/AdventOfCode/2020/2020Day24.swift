//
//  2020Day24.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/24/20.
//

import Foundation
import IsNotEmpty

private let exampleInput =
    """
    sesenwnenenewseeswwswswwnenewsewsw
    neeenesenwnwwswnenewnwwsewnenwseswesw
    seswneswswsenwwnwse
    nwnwneseeswswnenewneswwnewseswneseene
    swweswneswnenwsewnwneneseenw
    eesenwseswswnenwswnwnwsewwnwsene
    sewnenenenesenwsewnenwwwse
    wenwwweseeeweswwwnwwe
    wsweesenenewnwwnwsenewsenwwsesesenwne
    neeswseenwwswnwswswnw
    nenwswwsewswnenenewsenwsenwnesesenew
    enewnwewneswsewnwswenweswnenwsenwsw
    sweneswneswneneenwnewenewwneswswnese
    swwesenesewenwneswnwwneseswwne
    enesenwswwswneneswsenwnewswseenwsese
    wnwnesenesenenwwnenwsewesewsesesew
    nenewswnwewswnenesenwnesewesw
    eneswnwswnwsenenwnwnwwseeswneewsenese
    neswnwewnwnwseenwseesewsenwsweewe
    wseweeenwnesenwwwswnew
    """

extension Year2020 {

    public enum Day24: FullPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 24

        typealias Point = Point2D<Int>

        enum HexMovementDirection: String, CaseIterable {
            case east = "e"
            case southeast = "se"
            case southwest = "sw"
            case west = "w"
            case northeast = "ne"
            case northwest = "nw"
        }

        private static func movementDirections(
            for line: String
        ) -> [HexMovementDirection] {
            let searchOrder: [HexMovementDirection] =
                [.southeast, .southwest, .northeast, .northwest, .east, .west]

            var directions: [HexMovementDirection] = []

            var line = line

            while line.isNotEmpty {
                for direction in searchOrder {
                    if line.hasPrefix(direction.rawValue) {
                        line.removeFirst(direction.rawValue.count)
                        directions.append(direction)
                    }
                }
            }

            return directions
        }

        private static func move(
            _ point: Point,
            inHexDirection direction: HexMovementDirection
        ) -> Point {
            switch direction {
            case .east:
                return Point(x: point.x + 1, y: point.y)
            case .west:
                return Point(x: point.x - 1, y: point.y)
            case .northwest where point.y.isMultiple(of: 2):
                return Point(x: point.x - 1, y: point.y + 1)
            case .northwest:
                return Point(x: point.x, y: point.y + 1)
            case .northeast where point.y.isMultiple(of: 2):
                return Point(x: point.x, y: point.y + 1)
            case .northeast:
                return Point(x: point.x + 1, y: point.y + 1)
            case .southwest where point.y.isMultiple(of: 2):
                return Point(x: point.x - 1, y: point.y - 1)
            case .southwest:
                return Point(x: point.x, y: point.y - 1)
            case .southeast where point.y.isMultiple(of: 2):
                return Point(x: point.x, y: point.y - 1)
            case .southeast:
                return Point(x: point.x + 1, y: point.y - 1)
            }
        }

        private static func blackTiles(
            following directions: [[HexMovementDirection]]
        ) -> Set<Point> {
            var activatedPoints: Set<Point> = []

            for directionsToTile in directions {
                var point: Point = .origin

                for direction in directionsToTile {
                    point = move(point, inHexDirection: direction)
                }

                if activatedPoints.contains(point) {
                    activatedPoints.remove(point)
                }
                else {
                    activatedPoints.insert(point)
                }
            }

            return activatedPoints
        }

        public static func example1() -> String {
            var point: Point = .origin

            for direction in [HexMovementDirection.northwest, .west, .southwest,
                              .east, .east] {
                point = move(point, inHexDirection: direction)
            }

            precondition(point == .origin)

            let directions = parseInputLines(exampleInput,
                                             using: movementDirections(for:))

            return "\(blackTiles(following: directions).count)"
        }

        public static func part1() -> String {
            let directions = parseInputLines(puzzleInput(),
                                             using: movementDirections(for:))

            return "\(blackTiles(following: directions).count)"
        }

        private static func hexNeighbors(of point: Point) -> [Point] {
            HexMovementDirection.allCases.map {
                move(point, inHexDirection: $0)
            }
        }

        private static func state(after state: Set<Point>) -> Set<Point> {
            var nextState = state

            for point in state {
                let activeNeigbors = hexNeighbors(of: point)
                    .filter { state.contains($0) }
                    .count

                if ![1, 2].contains(activeNeigbors) {
                    nextState.remove(point)
                }
            }

            for point in state
                .flatMap(hexNeighbors(of:))
                .filter({ !state.contains($0) }) {
                let activeNeigbors = hexNeighbors(of: point)
                    .filter { state.contains($0) }
                    .count

                if activeNeigbors == 2 {
                    nextState.insert(point)
                }
            }

            return nextState
        }

        private static func tileState(
            following directions: [[HexMovementDirection]],
            afterDays days: Int
        ) -> Set<Point> {
            var state = blackTiles(following: directions)

            for day in 1 ... days {
                state = self.state(after: state)
                log("Day \(day): \(state.count)")
            }

            return state
        }

        public static func example2() -> String {
            let directions = parseInputLines(exampleInput,
                                             using: movementDirections(for:))

            return "\(tileState(following: directions, afterDays: 100).count)"
        }

        public static func part2() -> String {
            let directions = parseInputLines(puzzleInput(),
                                             using: movementDirections(for:))

            return "\(tileState(following: directions, afterDays: 100).count)"
        }

    }

}
