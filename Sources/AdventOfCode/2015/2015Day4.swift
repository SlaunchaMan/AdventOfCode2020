//
//  2015Day4.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import CryptoKit
import Foundation

extension Year2015 {

    public enum Day4: FullPuzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 4

        private static func lowestNumberSuffix(
            with secretKey: String,
            producingNumberOfZeroes zeroes: Int
        ) -> Int {
            let zeroString = String(repeating: "0", count: zeroes)

            let answerQueue = DispatchQueue(label: "answer",
                                            attributes: [.concurrent])

            var smallestAnswer: Int = .max

            (0...).forEachConcurrent { candidate in
                if let data = "\(secretKey)\(candidate)".data(using: .utf8) {
                    let hash = Insecure.MD5.hash(data: data)

                    let res = zeroes.quotientAndRemainder(dividingBy: 2)
                    let size = res.quotient + res.remainder

                    let prefixHash = hash.prefix(size)
                        .map { String(format: "%02hhx", $0) }
                        .joined()

                    if prefixHash.hasPrefix(zeroString) {
                        let answer = answerQueue.sync { smallestAnswer }

                        if answer > candidate {
                            answerQueue.async(flags: .barrier) {
                                smallestAnswer = candidate
                            }
                        }

                        return true
                    }
                }

                return false
            }

            return answerQueue.sync { smallestAnswer }
        }

        public static func example1() -> String {
            "\(lowestNumberSuffix(with: "abcdef", producingNumberOfZeroes: 5))"
        }

        public static func example2() -> String {
            "\(lowestNumberSuffix(with: "pqrstuv", producingNumberOfZeroes: 5))"
        }

        private static var input: String {
            puzzleInput()
        }

        public static func part1() -> String {
            "\(lowestNumberSuffix(with: input, producingNumberOfZeroes: 5))"
        }

        public static func part2() -> String {
            "\(lowestNumberSuffix(with: input, producingNumberOfZeroes: 6))"
        }

    }

}
