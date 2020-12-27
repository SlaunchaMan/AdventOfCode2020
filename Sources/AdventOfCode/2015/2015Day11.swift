//
//  2015Day11.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/7/20.
//

import Foundation

extension Character {

    func nextLetter() -> Character? {
        let alphabet = String.lowercaseAlphabet

        guard let index = alphabet.firstIndex(of: self) else { return nil }

        let nextIndex = alphabet.index(after: index)

        guard nextIndex != alphabet.endIndex else { return nil }

        return alphabet[nextIndex]
    }

}

extension String {

    var hasThreeLetterStraight: Bool {
        var iterator = makeIterator()

        guard var first = iterator.next(),
              var second = iterator.next()
        else { return false }

        while let third = iterator.next() {
            if second == first.nextLetter(), third == second.nextLetter() {
                return true
            }

            first = second
            second = third
        }

        return false
    }

    var hasTwoDifferentTwoLetterPairs: Bool {
        String.lowercaseAlphabet
            .map { "\($0)\($0)" }
            .count { self.contains($0) } >= 2
    }

}

extension Year2015 {

    public enum Day11: TwoPartPuzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 11

        private static func nextPassword(after oldPassword: String) -> String {
            var newPassword = ""

            var iterator = oldPassword.reversed().makeIterator()
            var shouldIncrement = true

            while let nextCharacter = iterator.next() {
                switch (shouldIncrement, nextCharacter) {
                case (false, _):
                    newPassword.append(nextCharacter)
                case (true, "z"):
                    newPassword.append("a")
                case (true, _):
                    guard let nextLetter = nextCharacter.nextLetter() else {
                        fatalError()
                    }

                    newPassword.append(nextLetter)
                    shouldIncrement = false
                }
            }

            return String(newPassword.reversed())
        }

        private static func passwordIsValid(_ password: String) -> Bool {
            if password.containsAny(in: ["i", "o", "l"]) { return false }
            if !password.hasThreeLetterStraight { return false }
            if !password.hasTwoDifferentTwoLetterPairs { return false }

            return true
        }

        private static func nextValidPassword(
            after password: String
        ) -> String {
            var password = password

            repeat {
                password = nextPassword(after: password)
            } while !passwordIsValid(password)

            return password
        }

        public static func part1() -> String {
            nextValidPassword(after: puzzleInput())
        }

        public static func part2() -> String {
            nextValidPassword(after: part1())
        }

    }

}
