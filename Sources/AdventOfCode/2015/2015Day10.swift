//
//  2015Day10.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/6/20.
//

import Foundation

extension Year2015 {

    public enum Day10: Puzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 10

        private static func lookAndSayStep(_ input: String,
                                           iterations: Int = 1) -> String {
            var input = input
            var output = ""

            for _ in 0 ..< iterations {
                output = ""
                var iterator = input.makeIterator()
                var currentCharacter = iterator.next()
                var counter = 1

                while let current = currentCharacter {
                    let next = iterator.next()

                    if current == next {
                        counter += 1
                    }
                    else {
                        output.append("\(counter)\(current)")
                        counter = 1
                        currentCharacter = next
                    }
                }

                input = output
            }

            return output
        }

        public static func part1() -> String {
            "\(lookAndSayStep(puzzleInput(), iterations: 40).count)"
        }

        public static func part2() -> String {
            "\(lookAndSayStep(puzzleInput(), iterations: 50).count)"
        }

    }

}
