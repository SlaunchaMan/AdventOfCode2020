//
//  2017Day8.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/28/20.
//

import Foundation

private let exampleInput =
    """
    b inc 5 if a > 1
    a inc 1 if b < 5
    c dec -10 if a >= 1
    c inc -20 if c == 10
    """

extension Year2017 {

    public enum Day8: FullPuzzle {

        public static let year: Year.Type = Year2017.self

        public static let day = 8

        enum Command {
            case increment(String, Int)
            case decrement(String, Int)

            init?(string: String) {
                let components = string.components(separatedBy: .whitespaces)
                guard components.count == 3,
                      let amount = Int(components[2])
                else { return nil }

                switch components[1] {
                case "inc": self = .increment(components[0], amount)
                case "dec": self = .decrement(components[0], amount)
                default:
                    preconditionFailure("Unknown command: \(components[1])")
                }
            }
        }

        enum Condition {
            case greaterThan(String, Int)
            case greaterThanOrEqualTo(String, Int)
            case equalTo(String, Int)
            case lessThan(String, Int)
            case lessThanOrEqualTo(String, Int)
            case notEqualTo(String, Int)

            init?(string: String) {
                let components = string.components(separatedBy: .whitespaces)
                guard components.count == 3,
                      let rhs = Int(components[2])
                else { return nil }

                let lhs = components[0]

                switch components[1] {
                case ">": self = .greaterThan(lhs, rhs)
                case ">=": self = .greaterThanOrEqualTo(lhs, rhs)
                case "==": self = .equalTo(lhs, rhs)
                case "<": self = .lessThan(lhs, rhs)
                case "<=": self = .lessThanOrEqualTo(lhs, rhs)
                case "!=": self = .notEqualTo(lhs, rhs)
                default:
                    preconditionFailure("Unknown operator: \(components[1])")
                }
            }

            func evaluate(_ lhs: Int) -> Bool {
                switch self {
                case let .greaterThan(_, rhs):
                    return lhs > rhs
                case let .greaterThanOrEqualTo(_, rhs):
                    return lhs >= rhs
                case let .equalTo(_, rhs):
                    return lhs == rhs
                case let .lessThan(_, rhs):
                    return lhs < rhs
                case let .lessThanOrEqualTo(_, rhs):
                    return lhs <= rhs
                case let .notEqualTo(_, rhs):
                    return lhs != rhs
                }
            }

            var register: String {
                switch self {
                case let .greaterThan(register, _),
                     let .greaterThanOrEqualTo(register, _),
                     let .equalTo(register, _),
                     let .lessThan(register, _),
                     let .lessThanOrEqualTo(register, _),
                     let .notEqualTo(register, _):
                    return register
                }
            }
        }

        struct Instruction {
            let command: Command
            let condition: Condition

            init?(string: String) {
                let components = string.components(separatedBy: " if ")

                guard components.count == 2,
                      let command = Command(string: components[0]),
                      let condition = Condition(string: components[1])
                else { return nil }

                self.command = command
                self.condition = condition
            }
        }

        struct Computer {
            var registers: [String: Int] = [:]
            var largestValueEverHeld = 0

            subscript(register: String) -> Int {
                get { registers[register, default: 0] }
                set {
                    registers[register] = newValue
                    if newValue > largestValueEverHeld {
                        largestValueEverHeld = newValue
                    }
                }
            }

            mutating func processInstructions(_ instructions: [Instruction]) {
                for instruction in instructions {
                    let condition = instruction.condition
                    let register = condition.register

                    if condition.evaluate(self[register]) {
                        switch instruction.command {
                        case let .increment(register, amount):
                            self[register] += amount
                        case let .decrement(register, amount):
                            self[register] -= amount
                        }
                    }
                }
            }
        }

        public static func example1() -> String {
            let instructions = parseInputLines(exampleInput,
                                               using: Instruction.init)

            var computer = Computer()
            computer.processInstructions(instructions)

            return "\(computer.registers.values.max()!)"
        }

        public static func part1() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            var computer = Computer()
            computer.processInstructions(instructions)

            return "\(computer.registers.values.max()!)"
        }

        public static func example2() -> String {
            let instructions = parseInputLines(exampleInput,
                                               using: Instruction.init)

            var computer = Computer()
            computer.processInstructions(instructions)

            return "\(computer.largestValueEverHeld)"
        }

        public static func part2() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            var computer = Computer()
            computer.processInstructions(instructions)

            return "\(computer.largestValueEverHeld)"
        }

    }

}
