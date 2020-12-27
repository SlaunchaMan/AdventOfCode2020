//
//  2016Day25.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/27/20.
//

import Foundation
import IsNotEmpty

extension Year2016 {

    public enum Day25: Puzzle {

        public static let year: Year.Type = Year2016.self

        public static let day = 25

        private static let iterationsNeeded = 4

        public static func part1() -> String {
            let computer = AssembunnyComputer(
                instructionsIn: parseInputLines(puzzleInput())
            )

            for input in 0... {
                log("Trying input \(input)…")
                var computer = computer
                computer["a"] = input

                var output = ""

                while output.count < iterationsNeeded * 2,
                      let next = computer.next() {
                    output.append("\(next)")
                }

                if output == String(repeating: "01", count: iterationsNeeded) {
                    return "\(input)"
                }
            }

            preconditionFailure()
        }

    }

}
