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

            for candidate in 0... {
                if let data = "\(secretKey)\(candidate)".data(using: .utf8) {
                    let hash = Insecure.MD5.hash(data: data)

                    let res = zeroes.quotientAndRemainder(dividingBy: 2)
                    let size = res.quotient + res.remainder

                    let prefixHash = hash.prefix(size)
                        .map { String(format: "%02hhx", $0) }
                        .joined()

                    if prefixHash.hasPrefix(zeroString) {
                        return candidate
                    }
                }
            }

            fatalError()
        }

        public static func example1() -> String {
            "\(lowestNumberSuffix(with: "abcdef", producingNumberOfZeroes: 5))"
        }

        public static func example2() -> String {
            "\(lowestNumberSuffix(with: "pqrstuv", producingNumberOfZeroes: 5))"
        }

        private static var input: String {
            puzzleInput().trimmingCharacters(in: .whitespacesAndNewlines)
        }

        public static func part1() -> String {
            "\(lowestNumberSuffix(with: input, producingNumberOfZeroes: 5))"
        }

        public static func part2() -> String {
            "\(lowestNumberSuffix(with: input, producingNumberOfZeroes: 6))"
        }

    }

}
