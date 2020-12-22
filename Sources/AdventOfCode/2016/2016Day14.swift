//
//  2016Day14.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/19/20.
//

import Crypto
import Foundation

extension Year2016 {

    public enum Day14: FullPuzzle {

        public static let year: Year.Type = Year2016.self

        public static let day = 14

        private static func key(at index: Int,
                                salt: String,
                                stretchCount: Int = 0) -> Int {
            let computedHashes = ConcurrentDictionary<Int, String>()

            func hash(_ index: Int) -> String {
                if let cached = computedHashes[index] { return cached }

                var hash = Insecure.MD5
                    .hash(data: Data("\(salt)\(index)".utf8))

                for _ in 0 ..< stretchCount {
                    hash = Insecure.MD5.hash(data: Data(hash.stringValue.utf8))
                }

                let stringValue = hash.stringValue

                computedHashes[index] = stringValue
                return stringValue
            }

            var foundKeys = 0

            for i in 0...Int.max {
                let md5 = hash(i)

                if let char = md5.firstElementRepeating(times: 3) {
                    let searchString = String(repeating: char, count: 5)

                    if ((i + 1) ... (i + 1000)).firstConcurrent(where: {
                        hash($0).contains(searchString)
                    }) != nil {
                        foundKeys += 1

                        log("Key #\(foundKeys): \(salt)\(i) -> \(md5)")

                        if foundKeys == index {
                            return i
                        }
                    }
                }

                computedHashes.removeValue(forKey: i)
            }

            fatalError("Got all the way to Int.max and didn't find a key!")
        }

        public static func example1() -> String {
            "\(key(at: 64, salt: "abc"))"
        }

        public static func part1() -> String {
            "\(key(at: 64, salt: puzzleInput()))"
        }

        public static func example2() -> String {
            "\(key(at: 64, salt: "abc", stretchCount: 2016))"
        }

        public static func part2() -> String {
            "\(key(at: 64, salt: puzzleInput(), stretchCount: 2016))"
        }

    }

}
