//
//  2020Day8.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/8/20.
//

import Foundation

private let exampleInput =
    """
    nop +0
    acc +1
    jmp +4
    acc +3
    jmp -3
    acc -99
    acc +1
    jmp -4
    acc +6
    """

extension Year2020 {

    public enum Day8: TwoPartPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 8

        enum Instruction {
            case acc(Int)
            case jmp(Int)
            case nop(Int)

            init?(string: String) {
                let scanner = Scanner(string: string)

                switch (scanner.scanUpToCharacters(from: .whitespaces),
                        scanner.scanInt()) {
                case ("acc", .some(let num)):
                    self = .acc(num)

                case ("jmp", .some(let num)):
                    self = .jmp(num)

                case ("nop", .some(let num)):
                    self = .nop(num)

                default:
                    return nil
                }
            }
        }

        enum ExitStatus {
            case infiniteLoop(Int)
            case normal(Int)
        }

        private static func execute(
            program instructions: [Instruction]
        ) -> ExitStatus {
            var pc = 0
            var acc = 0

            var visitedPCs = Set<Int>()

            while true {
                if visitedPCs.contains(pc) {
                    return .infiniteLoop(acc)
                }

                visitedPCs.insert(pc)

                switch instructions[pc] {
                case .acc(let num):
                    acc += num
                    pc += 1

                case .jmp(let num):
                    pc += num

                case .nop:
                    pc += 1
                }

                if pc >= instructions.count {
                    return .normal(acc)
                }
            }
        }

        public static func example1() -> String {
            let instructions = parseInputLines(exampleInput,
                                               using: Instruction.init)

            switch execute(program: instructions) {
            case .infiniteLoop(let acc), .normal(let acc):
                return "\(acc)"
            }
        }

        public static func part1() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            switch execute(program: instructions) {
            case .infiniteLoop(let acc), .normal(let acc):
                return "\(acc)"
            }
        }

        public static func example2() -> String {
            let instructions = parseInputLines(exampleInput,
                                               using: Instruction.init)

            for (index, instruction) in instructions.enumerated() {
                switch instruction {
                case .jmp(let num):
                    var newInst = instructions
                    newInst[index] = .nop(num)

                    if case let .normal(acc) = execute(program: newInst) {
                        return "\(acc)"
                    }

                case .nop(let num):
                    var newInst = instructions
                    newInst[index] = .jmp(num)

                    if case let .normal(acc) = execute(program: newInst) {
                        return "\(acc)"
                    }

                default:
                    break
                }
            }

            fatalError()
        }

        public static func part2() -> String {
            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            for (index, instruction) in instructions.enumerated() {
                switch instruction {
                case .jmp(let num):
                    var newInstr = instructions
                    newInstr[index] = .nop(num)

                    if case let .normal(acc) = execute(program: newInstr) {
                        return "\(acc)"
                    }

                case .nop(let num):
                    var newInst = instructions
                    newInst[index] = .jmp(num)

                    if case let .normal(acc) = execute(program: newInst) {
                        return "\(acc)"
                    }

                default:
                    break
                }
            }

            fatalError()
        }

    }

}
