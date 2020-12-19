//
//  2016Day12.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/18/20.
//

import Foundation

private let exampleInput =
    """
    cpy 41 a
    inc a
    inc a
    dec a
    jnz a 2
    dec a
    """

extension Year2016 {

    public enum Day12: PuzzleWithExample1 {

        public static let year: Year.Type = Year2016.self

        public static let day = 12

        enum InputValue {
            case number(Int)
            case register(String)

            init?(string: String) {
                if let value = Int(string) {
                    self = .number(value)
                }
                else if string.count == 1 {
                    self = .register(string)
                }
                else {
                    return nil
                }
            }
        }

        enum Instruction {
            case copy(source: InputValue, register: String)
            case increment(register: String)
            case decrement(register: String)
            case jumpIfNotZero(source: InputValue, offset: Int)

            init?(string: String) {
                let components = string.components(separatedBy: .whitespaces)

                guard (2...3).contains(components.count) else { return nil }

                switch components[0] {
                case "cpy":
                    if let source = InputValue(string: components[1]) {
                        self = .copy(source: source, register: components[2])
                    }
                    else {
                        return nil
                    }

                case "inc":
                    self = .increment(register: components[1])

                case "dec":
                    self = .decrement(register: components[1])

                case "jnz":
                    if let source = InputValue(string: components[1]),
                       let offset = Int(components[2]) {
                        self = .jumpIfNotZero(source: source, offset: offset)
                    }
                    else {
                        return nil
                    }

                default:
                    return nil
                }
            }
        }

        private static func process(
            instructions: [Instruction],
            beginningState: [String: Int] = [:]
        ) -> [String: Int] {
            var registers: [String: Int] = beginningState
            var pc = 0

            while pc < instructions.count {
                switch instructions[pc] {
                case let .copy(source: .number(number), register: register):
                    registers[register] = number
                case let .copy(source: .register(register), register: output):
                    registers[output] = registers[register]
                case let .increment(register: register):
                    registers[register, default: 0] += 1
                case let .decrement(register: register):
                    registers[register, default: 0] -= 1
                case let .jumpIfNotZero(source: .register(register),
                                        offset: offset):
                    if registers[register, default: 0] != 0 {
                        pc += offset
                        continue
                    }
                case let .jumpIfNotZero(source: .number(number),
                                        offset: offset):
                    if number != 0 {
                        pc += offset
                        continue
                    }
                }

                pc += 1
            }

            return registers
        }

        public static func example1() -> String {
            let instructions = parseInputLines(exampleInput,
                                               using: Instruction.init)

            return "\(process(instructions: instructions)["a", default: 0])"
        }

        public static func part1() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            return "\(process(instructions: instructions)["a", default: 0])"
        }

        public static func part2() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            let finalState = process(instructions: instructions,
                                     beginningState: ["c": 1])

            return "\(finalState["a", default: 0])"
        }

    }

}
