//
//  2016Day5.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/14/20.
//

import Crypto
import Foundation

extension Year2016 {

    public enum Day5: TwoPartPuzzle {

        public static let year: Year.Type = Year2016.self

        public static let day = 5

        private static func decryptPasswordPart1(doorID: String) -> String {
            var decryptedPassword = ""
            var index = 0
            let zeroString = String(repeating: "0", count: 5)

            var hash = Insecure.MD5.init()
            hash.update(data: Data("\(doorID)".utf8))

            while decryptedPassword.count < 8 {
                var candidateHash = hash
                candidateHash.update(data: Data("\(index)".utf8))
                let hashString = candidateHash.finalize().stringValue

                if hashString.hasPrefix(zeroString) {
                    let sixthIndex = hashString.index(hashString.startIndex,
                                                      offsetBy: 5)

                    decryptedPassword.append(hashString[sixthIndex])

                    log("\(doorID)\(index) -> \(hashString)")
                }

                index += 1
            }

            return decryptedPassword
        }

        public static func example1() -> String {
            decryptPasswordPart1(doorID: "abc")
        }

        public static func part1() -> String {
            decryptPasswordPart1(doorID: puzzleInput())
        }

        private static func decryptPasswordPart2(doorID: String) -> String {
            var decryptedPassword = String(repeating: "_", count: 8)
            var index = 0
            let zeroString = String(repeating: "0", count: 5)

            var hash = Insecure.MD5.init()
            hash.update(data: Data("\(doorID)".utf8))

            while decryptedPassword.contains("_") {
                var candidateHash = hash
                candidateHash.update(data: Data("\(index)".utf8))
                let hashString = candidateHash.finalize().stringValue

                if hashString.hasPrefix(zeroString) {
                    let sixthIndex = hashString.index(hashString.startIndex,
                                                      offsetBy: 5)

                    if let offset = Int(String(hashString[sixthIndex])),
                       (0..<8).contains(offset) {
                        let seventhIndex = hashString.index(after: sixthIndex)

                        let startIndex = decryptedPassword.index(
                            decryptedPassword.startIndex,
                            offsetBy: offset
                        )

                        if decryptedPassword[startIndex] == "_" {
                            let endIndex = decryptedPassword.index(
                                after: startIndex
                            )

                            decryptedPassword.replaceSubrange(
                                startIndex ..< endIndex,
                                with: String(hashString[seventhIndex])
                            )

                            // swiftlint:disable:next line_length
                            log("\(decryptedPassword) \(doorID)\(index) -> \(hashString)")
                        }
                    }
                }

                index += 1
            }

            return decryptedPassword
        }

        public static func example2() -> String {
            decryptPasswordPart2(doorID: "abc")
        }

        public static func part2() -> String {
            decryptPasswordPart2(doorID: puzzleInput())
        }

    }

}
