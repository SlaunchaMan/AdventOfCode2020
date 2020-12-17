//
//  2020Day12.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/12/20.
//

import Foundation

private let exampleInput =
    """
    F10
    N3
    F7
    R90
    F11
    """

extension Year2020 {

    public enum Day12: Puzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 12

        enum Instruction {
            case mapDirection(MapDirection, Int)
            case turn(TurnDirection, Int)
            case forward(Int)

            init?(string: String) {
                let scanner = Scanner(string: string)

                switch (scanner.scanCharacter(), scanner.scanInt()) {
                case ("N", .some(let dist)): self = .mapDirection(.north, dist)
                case ("S", .some(let dist)): self = .mapDirection(.south, dist)
                case ("E", .some(let dist)): self = .mapDirection(.east, dist)
                case ("W", .some(let dist)): self = .mapDirection(.west, dist)
                case ("L", .some(let degrees)): self = .turn(.left, degrees)
                case ("R", .some(let degrees)): self = .turn(.right, degrees)
                case ("F", .some(let dist)): self = .forward(dist)
                default: return nil
                }
            }
        }

        private static func nextLocationPart1(
            processing instruction: Instruction,
            startingAt initialPosition: Point2D<Int>,
            heading: MapDirection
        ) -> (Point2D<Int>, MapDirection) {
            var point = initialPosition
            var heading = heading

            switch (instruction, heading) {
            case (.forward(let distance), .north): point.y += distance
            case (.forward(let distance), .south): point.y -= distance
            case (.forward(let distance), .east): point.x += distance
            case (.forward(let distance), .west): point.x -= distance

            case let (.turn(direction, degrees), _):
                for _ in 0 ..< degrees / 90 {
                    // swiftlint:disable:next shorthand_operator
                    heading = heading + direction
                }

            case (.mapDirection(.north, let distance), _): point.y += distance
            case (.mapDirection(.south, let distance), _): point.y -= distance
            case (.mapDirection(.east, let distance), _): point.x += distance
            case (.mapDirection(.west, let distance), _): point.x -= distance
            }

            return (point, heading)
        }

        private static func finalLocationPart1(
            processing instructions: [Instruction]
        ) -> Point2D<Int> {
            var point: Point2D<Int> = .origin
            var heading: MapDirection = .east

            for instruction in instructions {
                (point, heading) = nextLocationPart1(processing: instruction,
                                                     startingAt: point,
                                                     heading: heading)
            }

            return point
        }

        public static func example1() -> String {
            let instructions = parseInputLines(exampleInput,
                                               using: Instruction.init(string:))

            let finalLocation = finalLocationPart1(processing: instructions)

            return "\(finalLocation.manhattanDistance(to: .origin))"
        }

        public static func part1() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init(string:))

            let finalLocation = finalLocationPart1(processing: instructions)

            return "\(finalLocation.manhattanDistance(to: .origin))"
        }

        private static func nextLocationPart2(
            processing instruction: Instruction,
            shipPosition: Point2D<Int>,
            waypoint: Point2D<Int>
        ) -> (Point2D<Int>, Point2D<Int>) {
            var shipPosition = shipPosition
            var waypoint = waypoint

            switch instruction {
            case .mapDirection(.north, let distance):
                waypoint.y += distance

            case .mapDirection(.south, let distance):
                waypoint.y -= distance

            case .mapDirection(.east, let distance):
                waypoint.x += distance

            case .mapDirection(.west, let distance):
                waypoint.x -= distance

            case .turn(.left, let degrees):
                for _ in 0 ..< degrees / 90 {
                    waypoint.rotate(clockwise: false)
                }

            case .turn(.right, let degrees):
                for _ in 0 ..< degrees / 90 {
                    waypoint.rotate(clockwise: true)
                }

            case .forward(let distance):
                shipPosition.x += (waypoint.x * distance)
                shipPosition.y += (waypoint.y * distance)
            }

            return (shipPosition, waypoint)
        }

        private static func finalLocationPart2(
            processing instructions: [Instruction]
        ) -> Point2D<Int> {
            var shipPoint: Point2D<Int> = .origin
            var waypoint = Point2D(x: 10, y: 1)

            for instruction in instructions {
                (shipPoint, waypoint) = nextLocationPart2(
                    processing: instruction,
                    shipPosition: shipPoint,
                    waypoint: waypoint
                )
            }

            return shipPoint
        }

        public static func example2() -> String {
            let instructions = parseInputLines(exampleInput,
                                               using: Instruction.init(string:))

            let finalLocation = finalLocationPart2(processing: instructions)

            return "\(finalLocation.manhattanDistance(to: .origin))"
        }

        public static func part2() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init(string:))

            let finalLocation = finalLocationPart2(processing: instructions)

            return "\(finalLocation.manhattanDistance(to: .origin))"
        }

    }

}
