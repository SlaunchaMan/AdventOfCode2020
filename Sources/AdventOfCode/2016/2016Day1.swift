//
//  2016Day1.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/13/20.
//

import Foundation

private let exampleInput1 =
    """
    R5, L5, R5, R3
    """

private let exampleInput2 =
    """
    R8, R4, R4, R8
    """

extension Year2016 {

    public enum Day1: Puzzle {

        public static let year: Year.Type = Year2016.self

        public static let day = 1

        struct Instruction {
            let direction: TurnDirection
            let distance: Int

            init?(string: String) {
                let scanner = Scanner(string: string)

                switch scanner.scanCharacter() {
                case "R": direction = .right
                case "L": direction = .left
                default: return nil
                }

                guard let distance = scanner.scanInt() else { return nil }
                self.distance = distance
            }
        }

        private static func processInstruction(
            _ instruction: Instruction,
            startingAt location: Point<Int>,
            heading: MapDirection
        ) -> (Point<Int>, MapDirection) {
            let newHeading = heading + instruction.direction
            var newLocation = location

            switch newHeading {
            case .north: newLocation.y += instruction.distance
            case .south: newLocation.y -= instruction.distance
            case .east: newLocation.x += instruction.distance
            case .west: newLocation.x -= instruction.distance
            }

            return (newLocation, newHeading)
        }

        private static func finalLocation(
            using instructions: [Instruction],
            startingAt location: Point<Int> = .origin,
            heading: MapDirection = .north
        ) -> Point<Int> {
            var location = location
            var heading = heading

            for instruction in instructions {
                (location, heading) = processInstruction(instruction,
                                                         startingAt: location,
                                                         heading: heading)
            }

            return location
        }

        public static func example1() -> String {
            let instructions = parseInput(exampleInput1, separatedBy: ", ")
                .compactMap(Instruction.init)

            let destination = finalLocation(using: instructions)

            return "\(destination.manhattanDistance(to: .origin))"
        }

        public static func part1() -> String {
            let instructions = parseInput(puzzleInput(), separatedBy: ", ")
                .compactMap(Instruction.init)

            let destination = finalLocation(using: instructions)

            return "\(destination.manhattanDistance(to: .origin))"
        }

        private static func firstRevisitedLocation(
            using instructions: [Instruction],
            startingAt location: Point<Int> = .origin,
            heading: MapDirection = .north
        ) -> Point<Int>? {
            var location = location
            var heading = heading
            var locations: Set<Point<Int>> = [location]

            for instrution in instructions {
                // swiftlint:disable:next shorthand_operator
                heading = heading + instrution.direction

                for _ in 0 ..< instrution.distance {
                    switch heading {
                    case .north: location.y += 1
                    case .south: location.y -= 1
                    case .east: location.x += 1
                    case .west: location.x -= 1
                    }

                    if locations.contains(location) {
                        return location
                    }

                    locations.insert(location)
                }
            }

            return nil
        }

        public static func example2() -> String {
            let instructions = parseInput(exampleInput2, separatedBy: ", ")
                .compactMap(Instruction.init)

            let destination = firstRevisitedLocation(using: instructions)

            return "\(destination!.manhattanDistance(to: .origin))"
        }

        public static func part2() -> String {
            let instructions = parseInput(puzzleInput(), separatedBy: ", ")
                .compactMap(Instruction.init)

            let destination = firstRevisitedLocation(using: instructions)

            return "\(destination!.manhattanDistance(to: .origin))"
        }

    }

}
