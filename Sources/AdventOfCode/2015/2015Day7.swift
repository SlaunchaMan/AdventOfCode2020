//
//  2015Day7.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation

private let exampleInput =
    """
    123 -> x
    456 -> y
    x AND y -> d
    x OR y -> e
    x LSHIFT 2 -> f
    y RSHIFT 2 -> g
    NOT x -> h
    NOT y -> i
    """

extension Year2015 {

    public enum Day7: PuzzleWithExample1 {

        public static let year: Year.Type = Year2015.self

        public static let day = 7

        enum Operator: CustomStringConvertible {
            case source(String)
            case and(String, String)
            case or(String, String)
            case lShift(String, Int)
            case rShift(String, Int)
            case not(String)

            init?(string: String) {
                let scanner = Scanner(string: string)

                if string.hasPrefix("NOT") {
                    _ = scanner.scanString("NOT ")

                    guard let input = scanner.scanUpToString(" ") else {
                        return nil
                    }

                    self = .not(input)
                }
                else if let lhs = scanner.scanUpToString(" ") {
                    if let op = scanner.scanUpToString(" "),
                       let rhs = scanner.scanUpToString(" ") {
                        switch op {
                        case "AND": self = .and(lhs, rhs)
                        case "OR": self = .or(lhs, rhs)
                        case "LSHIFT": self = .lShift(lhs, Int(rhs)!)
                        case "RSHIFT": self = .rShift(lhs, Int(rhs)!)
                        default: fatalError()
                        }
                    }
                    else {
                        self = .source(lhs)
                    }
                }
                else {
                    return nil
                }
            }

            var description: String {
                switch self {
                case let .source(value):
                    return "\(value)"
                case let .and(lhs, rhs):
                    return "\(lhs) AND \(rhs)"
                case let .or(lhs, rhs):
                    return "\(lhs) OR \(rhs)"
                case let .lShift(lhs, rhs):
                    return "\(lhs) LSHIFT \(rhs)"
                case let .rShift(lhs, rhs):
                    return "\(lhs) RSHIFT \(rhs)"
                case let .not(value):
                    return "NOT \(value)"
                }
            }

        }

        // swiftlint:disable:next function_body_length
        private static func evaluate(
            wire: String,
            inCircuit circuit: [String: Operator],
            using evaluatedWires: inout [String: UInt16]
        ) -> UInt16 {
            if let rawValue = UInt16(wire) {
                return rawValue
            }

            if let evaluated = evaluatedWires[wire] {
                return evaluated
            }

            switch circuit[wire] {
            case let .source(otherWire):
                if let rawValue = UInt16(otherWire) {
                    evaluatedWires[wire] = rawValue
                    return rawValue
                }
                else {
                    return evaluate(wire: otherWire,
                                    inCircuit: circuit,
                                    using: &evaluatedWires)
                }

            case let .and(lhs, rhs):
                let lhs = evaluate(wire: lhs,
                                   inCircuit: circuit,
                                   using: &evaluatedWires)
                let rhs = evaluate(wire: rhs,
                                   inCircuit: circuit,
                                   using: &evaluatedWires)

                let value = (lhs & rhs)
                evaluatedWires[wire] = value
                return value

            case let .or(lhs, rhs):
                let lhs = evaluate(wire: lhs,
                                   inCircuit: circuit,
                                   using: &evaluatedWires)
                let rhs = evaluate(wire: rhs,
                                   inCircuit: circuit,
                                   using: &evaluatedWires)

                return lhs | rhs

            case let .lShift(lhs, rhs):
                let lhs = evaluate(wire: lhs,
                                   inCircuit: circuit,
                                   using: &evaluatedWires)

                return lhs << rhs

            case let .rShift(lhs, rhs):
                let lhs = evaluate(wire: lhs,
                                   inCircuit: circuit,
                                   using: &evaluatedWires)

                return lhs >> rhs

            case let .not(wire):
                return ~evaluate(wire: wire,
                                 inCircuit: circuit,
                                 using: &evaluatedWires)

            default: fatalError()
            }
        }

        private static func circuit(for input: String) -> [String: Operator] {
            parseInputLines(
                input,
                using: { line -> (Operator, String)? in
                    let scanner = Scanner(string: line)

                    guard let opString = scanner.scanUpToString("->"),
                          let op = Operator(string: opString)
                    else { return nil }

                    _ = scanner.scanString("-> ")

                    let output = String(line[scanner.currentIndex...])

                    return (op, output)
                }
            )
            .reduce(into: [String: Operator]()) { (circuit, input) in
                let (op, output) = input

                circuit[output] = op
            }
        }

        private static func log(circuit: [String: Operator]) {
            circuit.forEach { (key, value) in
                AdventOfCode.log("\(value.description) -> \(key)")
            }
        }

        public static func example1() -> String {
            let circuit = self.circuit(for: exampleInput)

            log(circuit: circuit)

            var evaluatedWires: [String: UInt16] = [:]

            return circuit.keys.sorted().map {
                let value = evaluate(wire: $0,
                                     inCircuit: circuit,
                                     using: &evaluatedWires)

                return "\($0): \(value)"
            }
            .joined(separator: "\n")
        }

        public static func part1() -> String {
            let circuit = self.circuit(for: puzzleInput())

            log(circuit: circuit)

            var evaluatedWires: [String: UInt16] = [:]

            let wireA = evaluate(wire: "a",
                                 inCircuit: circuit,
                                 using: &evaluatedWires)

            AdventOfCode.log(evaluatedWires)

            return "\(wireA)"
        }

        public static func part2() -> String {
            var circuit = self.circuit(for: puzzleInput())

            log(circuit: circuit)

            var evaluatedWires: [String: UInt16] = [:]

            var wireA = evaluate(wire: "a",
                                 inCircuit: circuit,
                                 using: &evaluatedWires)

            circuit["b"] = .source("\(wireA)")

            evaluatedWires.removeAll()

            wireA = evaluate(wire: "a",
                                 inCircuit: circuit,
                                 using: &evaluatedWires)

            return "\(wireA)"
        }

    }

}
