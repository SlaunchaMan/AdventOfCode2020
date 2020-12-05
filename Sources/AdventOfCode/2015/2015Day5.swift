//
//  2015Day5.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation

extension String {

    var numberOfVowels: Int {
        let vowels = CharacterSet(charactersIn: "aeiou")

        return unicodeScalars.filter { vowels.contains($0) }.count
    }

    var hasRepeatedCharacter: Bool {
        var iterator = makeIterator()

        guard var first = iterator.next() else { return false }

        while let second = iterator.next() {
            if first == second {
                return true
            }

            first = second
        }

        return false
    }

    var hasRepeatedTwoCharacterSequence: Bool {
        var iterator = makeIterator()
        var index = self.index(after: startIndex)

        guard var first = iterator.next() else { return false }

        while let second = iterator.next() {
            index = self.index(after: index)

            if String(self[index...]).contains("\(first)\(second)") {
                return true
            }

            first = second
        }

        return false
    }

    // swiftlint:disable:next identifier_name
    var hasTwoCharacterSequenceWithACharacterBetween: Bool {
        var iterator = makeIterator()

        guard var first = iterator.next(),
              var second = iterator.next()
        else { fatalError() }

        while let third = iterator.next() {
            if first == third { return true }

            first = second
            second = third
        }

        return false
    }

}

extension Year2015 {

    public enum Day5: Puzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 5

        private static func stringIsNicePart1(_ string: String) -> Bool {
            if string.containsAny(in: ["ab", "cd", "pq", "xy"]) {

                return false
            }

            return string.hasRepeatedCharacter && string.numberOfVowels >= 3
        }

        public static func part1() -> String {
            "\(parseInputLines(puzzleInput()).filter(stringIsNicePart1).count)"
        }

        private static func stringIsNicePart2(_ string: String) -> Bool {
            switch (string.hasRepeatedTwoCharacterSequence,
                    string.hasTwoCharacterSequenceWithACharacterBetween) {
            case (true, true):
                log("\(string) is nice")
                return true
            case (false, false):
                log("\(string) is naughty, it does not satisfy either rule")
                return false
            case (false, _):
                log("\(string) is naughty, no repeated two-character sequence")
                return false
            case (_, false):
                log("\(string) is naughty, no two-character sequence 'aba'")
                return false
            }
        }

        public static func part2() -> String {
            "\(parseInputLines(puzzleInput()).filter(stringIsNicePart2).count)"
        }

    }

}
