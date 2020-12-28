//
//  Assembunny.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/27/20.
//

// swiftlint:disable file_length

import Foundation

private enum Value: CustomStringConvertible, Equatable, Hashable {

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

    var description: String {
        switch self {
        case let .number(number): return "\(number)"
        case let .register(register): return register
        }
    }

}

private enum Instruction: CustomStringConvertible, Equatable, Hashable {

    case copy(source: Value, destination: Value)
    case increment(value: Value)
    case decrement(value: Value)
    case jumpIfNotZero(source: Value, offset: Value)
    case toggle(offset: Value)
    case transmit(value: Value)

    // Optimized instructions not in the puzzles
    case noop
    case add(source: Value, destination: Value)
    case subtract(source: Value, destination: Value)
    case multiply(lhs: Value,
                  rhs: Value,
                  destination: Value)

    // swiftlint:disable:next cyclomatic_complexity
    init?(string: String) {
        let components = string.components(separatedBy: .whitespaces)

        guard (2...3).contains(components.count) else { return nil }

        switch components[0] {
        case "cpy":
            if let source = Value(string: components[1]),
               let destination = Value(string: components[2]) {
                self = .copy(source: source, destination: destination)
            }
            else {
                return nil
            }

        case "inc":
            if let value = Value(string: components[1]) {
                self = .increment(value: value)
            }
            else {
                return nil
            }

        case "dec":
            if let value = Value(string: components[1]) {
                self = .decrement(value: value)
            }
            else {
                return nil
            }

        case "jnz":
            if let source = Value(string: components[1]),
               let offset = Value(string: components[2]) {
                self = .jumpIfNotZero(source: source, offset: offset)
            }
            else {
                return nil
            }

        case "tgl":
            if let offset = Value(string: components[1]) {
                self = .toggle(offset: offset)
            }
            else {
                return nil
            }

        case "out":
            if let value = Value(string: components[1]) {
                self = .transmit(value: value)
            }
            else {
                return nil
            }

        default:
            return nil
        }
    }

    var description: String {
        switch self {
        case let .copy(source: source, destination: destination):
            return "cpy \(source) \(destination)"
        case let .increment(value: value):
            return "inc \(value)"
        case let .decrement(value: value):
            return "dec \(value)"
        case let .jumpIfNotZero(source: source, offset: offset):
            return "jnz \(source) \(offset)"
        case let .toggle(offset):
            return "tgl \(offset)"
        case let .transmit(value: value):
            return "out \(value)"
        case let .add(source: source, destination: destination):
            return "add \(source) \(destination)"
        case let .subtract(source: source, destination: destination):
            return "sub \(source) \(destination)"
        case let .multiply(lhs: lhs, rhs: rhs, destination: destination):
            return "mul \(lhs) \(rhs) \(destination)"
        case .noop:
            return "noop"
        }
    }

    mutating func toggle() {
        switch self {
        case let .copy(source: source, destination: destination):
            self = .jumpIfNotZero(source: source,
                                  offset: destination)

        case let .increment(value):
            self = .decrement(value: value)

        case let .decrement(value),
             let .toggle(offset: value):
            self = .increment(value: value)

        case let .jumpIfNotZero(source: source, offset: offset):
            self = .copy(source: source, destination: offset)

        case .transmit:
            preconditionFailure("Undefined behavior")

        case .add, .subtract, .noop, .multiply:
            preconditionFailure("Attempted to toggle optimized code")
        }
    }

    private typealias Optimization = ([Instruction]) -> (
        didOptimize: Bool,
        optimizedInstructions: [Instruction]
    )

    // inc a, dec b, jnz b -2 -> add b a, cpy 0 b, noop
    private static func optimizeAdd(
        _ instructions: [Instruction]
    ) -> (didOptimize: Bool, optimizedInstructions: [Instruction]) {
        for index in 0 ..< instructions.count - 4 {
            if case let .increment(a) = instructions[index],
               case let .decrement(.register(b)) = instructions[index + 1],
               case let .jumpIfNotZero(
                source: .register(b2),
                offset: .number(negativeTwo)
               ) = instructions[index + 2],
               b == b2, negativeTwo == -2 {
                var optimizedInstructions = instructions

                optimizedInstructions.replaceSubrange(
                    index ... index + 2,
                    with: [.add(source: .register(b),
                                destination: a),
                           .copy(source: .number(0),
                                 destination: .register(b)),
                           .noop]
                )

                return (true, optimizedInstructions)
            }
        }

        return (false, instructions)
    }

    // cpy c b, add b a, cpy 0 b, noop, dec d, jnz d -5 ->
    // mul c d b, add b a, cpy 0 b, cpy 0 d, noop, noop
    private static func optimizeMultiply(
        _ instructions: [Instruction]
    ) -> (didOptimize: Bool, optimizedInstructions: [Instruction]) {
        for index in 0 ..< instructions.count - 6 {
            if case let .copy(c, .register(b)) =
                instructions[index],
               case let .add(.register(b2), .register(a)) =
                instructions[index + 1],
               case let .copy(.number(zero), .register(b3)) =
                instructions[index + 2],
               case .noop = instructions[index + 3],
               case let .decrement(.register(d)) = instructions[index + 4],
               case let .jumpIfNotZero(.register(d2), .number(negativeFive)) =
                instructions[index + 5],
               b == b2, b2 == b3, d == d2, zero == 0, negativeFive == -5 {
                var newInstructions = instructions

                newInstructions.replaceSubrange(
                    index ... index + 5,
                    with: [.multiply(lhs: c,
                                     rhs: .register(d),
                                     destination: .register(b)),
                           .add(source: .register(b),
                                destination: .register(a)),
                           .copy(source: .number(0),
                                 destination: .register(b)),
                           .copy(source: .number(0),
                                 destination: .register(d)),
                           .noop,
                           .noop]
                )

                return (true, newInstructions)
            }
        }

        return (false, instructions)
    }

    fileprivate static func optimize(
        _ instructions: [Instruction]
    ) -> [Instruction] {
        var optimized = instructions

        for optimization: Optimization in [
            optimizeAdd, optimizeMultiply
        ] {
            var didOptimize = false
            repeat {
                (didOptimize, optimized) = optimization(optimized)
            } while didOptimize
        }

        return optimized
    }

}

struct AssembunnyComputer {

    typealias RegisterState = [String: Int]

    private var instructions: [Instruction] {
        didSet {
            optimizedInstructions = Instruction.optimize(instructions)
        }
    }

    private var optimizedInstructions: [Instruction]

    private var pc = 0
    var registers: RegisterState

    subscript(register: String) -> Int {
        get { registers[register, default: 0] }
        set { registers[register] = newValue }
    }

    private init(instructions: [Instruction],
                 initialRegisterState registers: RegisterState = [:]) {
        self.instructions = instructions
        self.optimizedInstructions = Instruction.optimize(instructions)
        self.registers = registers
    }

    init(instructionsIn input: [String],
         initialRegisterState registers: RegisterState = [:]) {
        self.init(instructions: input.compactMap(Instruction.init),
                  initialRegisterState: registers)
    }

    private func dereference(_ value: Value) -> Int {
        switch value {
        case let .number(number): return number
        case let .register(register): return self[register]
        }
    }

    private func valueDescription(_ value: Value) -> String {
        switch value {
        case let .number(number): return "\(number)"
        case let .register(register):
            return "register \(register) (\(dereference(value)))"
        }
    }

    mutating func runToEnd() -> RegisterState {
        while next() != nil {}

        return registers
    }

}

extension AssembunnyComputer: IteratorProtocol, Sequence {

    // swiftlint:disable:next function_body_length cyclomatic_complexity
    mutating func next() -> Int? {
        guard pc < optimizedInstructions.count else { return nil }

        while pc < optimizedInstructions.count {
            log("Executing instruction at index \(pc)")

            switch optimizedInstructions[pc] {
            case let .copy(source: source,
                           destination: .register(register)):
                log("Copying value \(valueDescription(source)) to \(register)")
                self[register] = dereference(source)

            case let .increment(value: .register(register)):
                let newValue = self[register] + 1
                log("Incrementing register \(register) to \(newValue)")
                self[register] = newValue

            case let .decrement(value: .register(register)):
                let newValue = self[register] - 1
                log("Decrementing register \(register) to \(newValue)")
                self[register] = newValue

            case let .jumpIfNotZero(source: source, offset: offset):
                if dereference(source) != 0 {
                    // swiftlint:disable:next line_length
                    log("\(valueDescription(source)) is not 0, jumping by \(valueDescription(offset))")
                    pc += dereference(offset)
                    continue
                }
                else {
                    log("\(valueDescription(source)) is 0, not jumping")
                }

            case let .toggle(offset: offset):
                let target = pc + dereference(offset)

                if target < instructions.count {
                    let oldInstruction = instructions[target]
                    instructions[target].toggle()

                    // swiftlint:disable:next line_length
                    log("Toggling instruction at index \(target): \(oldInstruction) -> \(instructions[target])")

                    optimizedInstructions = Instruction.optimize(instructions)
                }
                else {
                    log("\(target) is outside valid range, ignoring toggle")
                }

            case let .transmit(value: value):
                log("Transmitting \(valueDescription(value))…")
                pc += 1
                return dereference(value)

            case let .add(source: source, destination: .register(register)):
                // swiftlint:disable:next line_length
                log("Adding \(valueDescription(source)) to register \(register)")
                self[register] += dereference(source)

            case let .subtract(source: source,
                               destination: .register(register)):
                // swiftlint:disable:next line_length
                log("Subtracting \(valueDescription(source)) from register \(register)")
                self[register] -= dereference(source)

            case let .multiply(lhs: lhs,
                               rhs: rhs,
                               destination: .register(register)):
                // swiftlint:disable:next line_length
                log("Multiplying \(valueDescription(lhs)) by \(valueDescription(rhs)) and storing in register \(register)")
                self[register] = dereference(lhs) * dereference(rhs)

            case .copy(source: _, destination: .number),
                 .increment(value: .number),
                 .decrement(value: .number),
                 .add(source: _, destination: .number),
                 .subtract(source: _, destination: .number),
                 .multiply(lhs: _, rhs: _, destination: .number):
                log("Ignoring invalid instruction: \(instructions[pc])")

            case .noop:
                log("noop")
            }

            pc += 1
        }

        return nil
    }

}

extension AssembunnyComputer: Equatable {

    static func == (lhs: AssembunnyComputer, rhs: AssembunnyComputer) -> Bool {
        lhs.pc == rhs.pc &&
            lhs.registers == rhs.registers &&
            lhs.instructions == rhs.instructions
    }

}

extension AssembunnyComputer: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(pc)
        hasher.combine(registers)
        hasher.combine(instructions)
    }

}
