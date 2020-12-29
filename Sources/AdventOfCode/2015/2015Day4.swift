//
//  2015Day4.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Crypto
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

            var hash = Insecure.MD5.init()
            hash.update(data: Data(secretKey.utf8))

            return (0...).concurrentFirst { candidate in
                var candidateHash = hash
                candidateHash.update(data: Data("\(candidate)".utf8))

                return candidateHash.finalize().stringValue
                    .hasPrefix(zeroString)
            }!
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
