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

        enum Instruction: String {
            case north = "^"
            case south = "v"
            case east = ">"
            case west = "<"
        }

        struct House: Hashable, Equatable, CustomStringConvertible {
            // swiftlint:disable identifier_name 
            var x: Int
            var y: Int
            // swiftlint:enable identifier_name

            static let origin = House(x: 0, y: 0)

            var description: String {
                "(\(x), \(y))"
            }

            mutating func apply(_ instruction: Instruction) {
                switch instruction {
                case .north:
                    y -= 1
                case .south:
                    y += 1
                case .east:
                    x += 1
                case .west:
                    x -= 1
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
                position.apply(instruction)
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
                santaPosition.apply(santaInstruction)
                presents[santaPosition, default: 0] += 1

                if let roboSantaInstruction = instructionIterator.next() {
                    roboSantaPosition.apply(roboSantaInstruction)
                    presents[roboSantaPosition, default: 0] += 1
                }
            }

            return "\(presents.keys.count)"
        }

    }

}
