//
//  2015Day3.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation

extension Year2015 {

    public enum Day3: Puzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 3

        typealias House = Point2D<Int>

        enum Instruction: String {
            case north = "^"
            case south = "v"
            case east = ">"
            case west = "<"

            func apply(to house: inout House) {
                switch self {
                case .north:
                    house.y -= 1
                case .south:
                    house.y += 1
                case .east:
                    house.x += 1
                case .west:
                    house.x -= 1
                }
            }
        }

        private static var instructions: [Instruction] {
            puzzleInput()
                .map(String.init)
                .compactMap(Instruction.init(rawValue:))
        }

        public static func part1() -> String {
            var presents: [House: Int] = [.origin: 1]
            var position: House = .origin

            var instructionIterator = instructions.makeIterator()

            while let instruction = instructionIterator.next() {
                instruction.apply(to: &position)
                presents[position, default: 0] += 1
            }

            return "\(presents.keys.count)"
        }

        public static func part2() -> String {
            var presents: [House: Int] = [.origin: 2]
            var santaPosition: House = .origin
            var roboSantaPosition: House = .origin

            var instructionIterator = instructions.makeIterator()

            while let santaInstruction = instructionIterator.next() {
                santaInstruction.apply(to: &santaPosition)
                presents[santaPosition, default: 0] += 1

                if let roboSantaInstruction = instructionIterator.next() {
                    roboSantaInstruction.apply(to: &roboSantaPosition)
                    presents[roboSantaPosition, default: 0] += 1
                }
            }

            return "\(presents.keys.count)"
        }

    }

}
