//
//  2016Day21.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/23/20.
//

import Algorithms
import Foundation

private let exampleInput =
    """
    swap position 4 with position 0
    swap letter d with letter b
    reverse positions 0 through 4
    rotate left 1
    move position 1 to position 4
    move position 3 to position 0
    rotate based on position of letter b
    rotate based on position of letter d
    """

extension Year2016 {

    public enum Day21: PuzzleWithExample1 {

        public static let year: Year.Type = Year2016.self

        public static let day = 21

        enum Instruction {
            case swapIndexes(Int, Int)
            case swapElements(Character, Character)
            case rotateRight(Int)
            case rotateLeft(Int)
            case rotateTo(Character)
            case reverse(ClosedRange<Int>)
            case move(Int, Int)

            // swiftlint:disable:next cyclomatic_complexity
            init?(string: String) {
                var words = string.components(separatedBy: .whitespaces)

                guard words.count > 1 else { return nil }

                switch [words.removeFirst(), words.removeFirst()]
                    .joined(separator: " ") {
                case "swap position":
                    guard let indexA = Int(words.removeFirst()),
                          let indexB = Int(words.removeLast())
                    else { return nil }

                    self = .swapIndexes(indexA, indexB)

                case "swap letter":
                    guard let letterA = words.removeFirst().first,
                          let letterB = words.removeLast().first
                    else { return nil }

                    self = .swapElements(letterA, letterB)

                case "rotate left":
                    guard let steps = Int(words.removeFirst())
                    else { return nil }

                    self = .rotateLeft(steps)

                case "rotate right":
                    guard let steps = Int(words.removeFirst())
                    else { return nil }

                    self = .rotateRight(steps)

                case "rotate based":
                    guard let letter = words.removeLast().first
                    else { return nil }

                    self = .rotateTo(letter)

                case "reverse positions":
                    guard let indexA = Int(words.removeFirst()),
                          let indexB = Int(words.removeLast())
                    else { return nil }

                    self = .reverse(indexA ... indexB)

                case "move position":
                    guard let indexA = Int(words.removeFirst()),
                          let indexB = Int(words.removeLast())
                    else { return nil }

                    self = .move(indexA, indexB)

                default:
                    return nil
                }
            }
        }

        private static func rotateBasedOnOffset(for startIndex: Int) -> Int {
            1 + startIndex + (startIndex >= 4 ? 1 : 0)
        }

        private static func offsetForRotateBasedOn(endIndex: Int) -> Int {
            (0...).first { $0 + rotateBasedOnOffset(for: $0) == endIndex }!
        }

        private static func apply(instruction: Instruction,
                                  to string: String) -> String {
            var characters = Array(string)

            switch instruction {
            case let .swapIndexes(indexA, indexB):
                characters.swapAt(indexA, indexB)

            case let .swapElements(letterA, letterB):
                guard let indexA = characters.firstIndex(of: letterA),
                      let indexB = characters.firstIndex(of: letterB)
                else { return string }

                characters.swapAt(indexA, indexB)

            case let .rotateRight(offset):
                characters.rotateRight(offset)

            case let .rotateLeft(offset):
                characters.rotateLeft(offset)

            case let .rotateTo(letter):
                guard let index = characters.firstIndex(of: letter)
                else { return string }

                let offset = rotateBasedOnOffset(for: index)

                characters.rotateRight(offset)

            case let .reverse(range):
                characters.reverse(subrange: Range(range))

            case let .move(from, to):
                let letter = characters.remove(at: from)
                characters.insert(letter, at: to)
            }

            return String(characters)
        }

        public static func example1() -> String {
            let instructions = parseInputLines(exampleInput,
                                               using: Instruction.init)

            var string = "abcde"

            for instruction in instructions {
                string = apply(instruction: instruction, to: string)
            }

            return string
        }

        public static func part1() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            var string = "abcdefgh"

            for instruction in instructions {
                string = apply(instruction: instruction, to: string)
            }

            return string
        }

        private static func reverse(instruction: Instruction,
                                    in string: String) -> String {
            var characters = Array(string)

            switch instruction {
            case let .swapIndexes(indexA, indexB):
                characters.swapAt(indexA, indexB)

            case let .swapElements(letterA, letterB):
                guard let indexA = characters.firstIndex(of: letterA),
                      let indexB = characters.firstIndex(of: letterB)
                else { return string }

                characters.swapAt(indexA, indexB)

            case let .rotateRight(offset):
                characters.rotateLeft(offset)

            case let .rotateLeft(offset):
                characters.rotateRight(offset)

            case let .rotateTo(letter):
                let count = string.count
                let startToEndIndexes: [Int: Int] = (0 ..< count)
                    .reduce(into: [:]) {
                        $0[$1] = ($1 + rotateBasedOnOffset(for: $1)) % count
                    }

                let endIndexToOffsets: [Int: Int] = startToEndIndexes
                    .reduce(into: [:]) {
                        $0[$1.value] = $1.value - $1.key
                    }

                guard let index = characters.firstIndex(of: letter),
                      let offset = endIndexToOffsets[index]
                else { return string }

                if offset < 0 {
                    characters.rotateRight(-offset)
                }
                else {
                    characters.rotateLeft(offset)
                }

            case let .reverse(range):
                characters.reverse(subrange: Range(range))

            case let .move(from, to):
                let letter = characters.remove(at: to)
                characters.insert(letter, at: from)
            }

            return String(characters)
        }

        public static func part2() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            var string = "fbgdceah"

            for instruction in instructions.reversed() {
                string = reverse(instruction: instruction, in: string)
            }

            return string
        }

    }

}
