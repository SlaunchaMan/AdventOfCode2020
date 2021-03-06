//
//  2016Day12.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/18/20.
//

import Foundation

private let exampleInput =
    """
    cpy 41 a
    inc a
    inc a
    dec a
    jnz a 2
    dec a
    """

extension Year2016 {

    public enum Day12: PuzzleWithExample1 {

        public static let year: Year.Type = Year2016.self

        public static let day = 12

        public static func example1() -> String {
            var computer = AssembunnyComputer(
                instructionsIn: parseInputLines(exampleInput)
            )

            return "\(computer.runToEnd()["a", default: 0])"
        }

        public static func part1() -> String {
            var computer = AssembunnyComputer(
                instructionsIn: parseInputLines(puzzleInput())
            )

            return "\(computer.runToEnd()["a", default: 0])"
        }

        public static func part2() -> String {
            var computer = AssembunnyComputer(
                instructionsIn: parseInputLines(puzzleInput()),
                initialRegisterState: ["c": 1]
            )

            return "\(computer.runToEnd()["a", default: 0])"
        }

    }

}
