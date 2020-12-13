//
//  2015Day23.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/12/20.
//

import Foundation

private let exampleInput =
    """
    inc a
    jio a, +2
    tpl a
    inc a
    """

extension Year2015 {

    public enum Day23: Puzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 23

        typealias Register = Character

        enum Instruction {
            case half(Register)
            case triple(Register)
            case increment(Register)
            case jump(Int)
            case jumpIfEven(Register, Int)
            case jumpIfOne(Register, Int)

            // swiftlint:disable:next cyclomatic_complexity
            init?(string: String) {
                let scanner = Scanner(string: string)

                guard let inst = scanner.scanUpToCharacters(from: .whitespaces)
                else { return nil }

                switch inst {
                case "hlf":
                    guard let register = scanner.scanCharacter()
                    else { return nil }
                    self = .half(register)

                case "tpl":
                    guard let register = scanner.scanCharacter()
                    else { return nil }
                    self = .triple(register)

                case "inc":
                    guard let register = scanner.scanCharacter()
                    else { return nil }
                    self = .increment(register)

                case "jmp":
                    guard let offset = scanner.scanInt() else { return nil }
                    self = .jump(offset)

                case "jie":
                    guard let register = scanner.scanCharacter(),
                          scanner.scanUpToCharacters(from: .whitespaces) != nil,
                          let offset = scanner.scanInt()
                    else { return nil }
                    self = .jumpIfEven(register, offset)

                case "jio":
                    guard let register = scanner.scanCharacter(),
                          scanner.scanUpToCharacters(from: .whitespaces) != nil,
                          let offset = scanner.scanInt()
                    else { return nil }
                    self = .jumpIfOne(register, offset)

                default: return nil
                }
            }
        }

        struct Computer {

            var registers: [Register: UInt] = ["a": 0, "b": 0]

            subscript(_ register: Register) -> UInt {
                get { registers[register, default: 0] }
                set { registers[register] = newValue }
            }

            mutating func execute(_ instructions: [Instruction]) {
                var pc = 0

                while pc < instructions.count {
                    let instruction = instructions[pc]

                    switch instruction {
                    case let .half(register):
                        self[register] /= 2
                        pc += 1

                    case let .triple(register):
                        self[register] *= 3
                        pc += 1

                    case let .increment(register):
                        self[register] += 1
                        pc += 1

                    case let .jump(offset):
                        pc += offset

                    case let .jumpIfEven(register, offset):
                        if self[register].isMultiple(of: 2) {
                            pc += offset
                        }
                        else {
                            pc += 1
                        }

                    case let .jumpIfOne(register, offset):
                        if self[register] == 1 {
                            pc += offset
                        }
                        else {
                            pc += 1
                        }
                    }
                }
            }

        }

        public static func example1() -> String {
            let instructions = parseInputLines(exampleInput,
                                               using: Instruction.init)

            var computer = Computer()
            computer.execute(instructions)

            return "\(computer["a"])"
        }

        public static func part1() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            var computer = Computer()
            computer.execute(instructions)

            return "\(computer["b"])"
        }

        public static func part2() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            var computer = Computer()
            computer["a"] = 1
            computer.execute(instructions)

            return "\(computer["b"])"
        }

    }

}
