//
//  2016Day23.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/27/20.
//

import Foundation

private let exampleInput =
    """
    cpy 2 a
    tgl a
    tgl a
    tgl a
    cpy 1 a
    dec a
    dec a
    """

extension Year2016 {

    public enum Day23: PuzzleWithExample1 {

        public static let year: Year.Type = Year2016.self

        public static let day = 23

        public static func example1() -> String {
            var computer = AssembunnyComputer(
                instructionsIn: parseInputLines(exampleInput)
            )

            return "\(computer.runToEnd()["a", default: 0])"
        }

        public static func part1() -> String {
            var computer = AssembunnyComputer(
                instructionsIn: parseInputLines(puzzleInput()),
                initialRegisterState: ["a": 7]
            )

            return "\(computer.runToEnd()["a", default: 0])"
        }

        public static func part2() -> String {
            var computer = AssembunnyComputer(
                instructionsIn: parseInputLines(puzzleInput()),
                initialRegisterState: ["a": 12]
            )

            return "\(computer.runToEnd()["a", default: 0])"
        }

    }

}
