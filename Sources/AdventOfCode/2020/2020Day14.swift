//
//  2020Day14.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/14/20.
//

import Algorithms
import Foundation

private let exampleInput1 =
    """
    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
    mem[8] = 11
    mem[7] = 101
    mem[8] = 0
    """

private let exampleInput2 =
    """
    mask = 000000000000000000000000000000X1001X
    mem[42] = 100
    mask = 00000000000000000000000000000000X0XX
    mem[26] = 1
    """

extension Year2020 {

    public enum Day14: TwoPartPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 14

        enum Instruction {
            case setMask(String)
            case setAddressToValue(Int, Int)

            init?(string: String) {
                if string.hasPrefix("mask = ") {
                    self = .setMask(String(string.suffix(36)))
                }
                else if string.hasPrefix("mem") {
                    let scanner = Scanner(string: string)

                    guard scanner.scanString("mem[") != nil,
                          let address = scanner.scanInt(),
                          scanner.scanString("] = ") != nil,
                          let value = scanner.scanInt()
                    else { return nil }

                    self = .setAddressToValue(address, value)
                }
                else {
                    return nil
                }
            }
        }

        private static func stringRepresentation(for number: Int) -> String {
            // Start with a 36-character wide string of "0"
            var string = String(repeating: "0", count: 36)
            let convertedToBinary = String(number, radix: 2)

            let startIndex = string.index(string.endIndex,
                                          offsetBy: -convertedToBinary.count)

            string.replaceSubrange(startIndex ..< string.endIndex,
                                   with: convertedToBinary)

            return string
        }

        private static func number(for stringRepresentation: String) -> Int? {
            Int(stringRepresentation, radix: 2)
        }

        private static func applyMaskPart1(_ mask: String,
                                           to string: String) -> String {
            var output = string

            for (maskCharacter, (index, _)) in zip(mask, output.indexed())
            where maskCharacter != "X" {
                output.replaceSubrange(index ..< output.index(after: index),
                                       with: String(maskCharacter))
            }

            return output
        }

        private static func processPart1(
            instructions: [Instruction]
        ) -> [Int: Int] {
            var values: [Int: Int] = [:]
            var mask: String = String(repeating: "X", count: 36)

            for instruction in instructions {
                switch instruction {
                case let .setMask(newMask): mask = newMask

                case let .setAddressToValue(address, value):
                    let string = stringRepresentation(for: value)
                    let masked = applyMaskPart1(mask, to: string)
                    let value = number(for: masked)

                    values[address] = value
                }
            }

            return values
        }

        public static func example1() -> String {
            let instructions = parseInputLines(exampleInput1,
                                               using: Instruction.init)

            let values = processPart1(instructions: instructions)

            return "\(values.values.sum())"
        }

        private static func applyMaskPart2(_ mask: String,
                                           to string: String) -> [String] {
            var output = [String()]

            for (maskCharacter, stringCharacter) in zip(mask, string) {
                switch (maskCharacter, stringCharacter) {
                case ("0", let char):
                    output = output.map { $0 + String(char) }

                case ("1", _):
                    output = output.map { $0 + "1" }

                case ("X", _):
                    output = output.map { $0 + "0" } + output.map { $0 + "1" }

                default: break
                }
            }

            return output
        }

        private static func processPart2(
            instructions: [Instruction]
        ) -> [Int: Int] {
            var values: [Int: Int] = [:]
            var mask: String = String(repeating: "X", count: 36)

            for instruction in instructions {
                switch instruction {
                case let .setMask(newMask): mask = newMask

                case let .setAddressToValue(address, value):
                    let string = stringRepresentation(for: address)
                    for masked in applyMaskPart2(mask, to: string) {
                        if let address = number(for: masked) {
                            values[address] = value
                        }
                    }
                }
            }

            return values
        }

        public static func part1() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            let values = processPart1(instructions: instructions)

            return "\(values.values.sum())"
        }

        public static func example2() -> String {
            let instructions = parseInputLines(exampleInput2,
                                               using: Instruction.init)

            let values = processPart2(instructions: instructions)

            return "\(values.values.sum())"
        }

        public static func part2() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            let values = processPart2(instructions: instructions)

            return "\(values.values.sum())"
        }

    }

}
