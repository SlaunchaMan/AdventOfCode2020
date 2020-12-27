//
//  2020Day25.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/25/20.
//

import Foundation

extension Year2020 {

    public enum Day25: PuzzleWithExample1 {

        public static let year: Year.Type = Year2020.self

        public static let day = 25

        private static func transform(subject: Int, loopSize: Int) -> Int {
            var value = 1

            for _ in 0 ..< loopSize {
                value *= subject
                value %= 20201227
            }

            return value
        }

        private static func loopSize(for key: Int) -> Int {
            var subject = 1

            for loopSize in 1... {
                subject *= 7
                subject %= 20201227

                if subject == key {
                    log("Loop size for key \(key) is \(loopSize)")
                    return loopSize
                }
            }

            preconditionFailure()
        }

        private static func encryptionKey(doorKey: Int, cardKey: Int) -> Int {
            let cardLoopSize = loopSize(for: cardKey)
            let doorLoopSize = loopSize(for: doorKey)

            if doorLoopSize < cardLoopSize {
                return transform(subject: cardKey, loopSize: doorLoopSize)
            }
            else {
                return transform(subject: doorKey, loopSize: cardLoopSize)
            }
        }

        public static func example1() -> String {
            "\(encryptionKey(doorKey: 17807724, cardKey: 5764801))"
        }

        public static func part1() -> String {
            let components = puzzleInput().components(separatedBy: .newlines)
            let door = Int(components[0])!
            let card = Int(components[1])!

            return "\(encryptionKey(doorKey: door, cardKey: card))"
        }

    }

}
