//
//  2020Day16.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/16/20.
//

import Foundation

private let exampleInput =
    """
    class: 1-3 or 5-7
    row: 6-11 or 33-44
    seat: 13-40 or 45-50

    your ticket:
    7,1,14

    nearby tickets:
    7,3,47
    40,4,50
    55,2,20
    38,6,12
    """

// swiftlint:disable large_tuple
extension Year2020 {

    public enum Day16: PuzzleWithExample1 {

        public static let year: Year.Type = Year2020.self

        public static let day = 16

        private static func field(from line: String) -> (String, IndexSet)? {
            let outerComponents = line.components(separatedBy: ": ")

            guard outerComponents.count == 2 else { return nil }

            let innerComponents = outerComponents[1]
                .components(separatedBy: " or ")

            guard innerComponents.count == 2 else { return nil }

            return (outerComponents[0],
                    innerComponents.reduce(into: IndexSet()) {
                        let numbers = $1.components(separatedBy: "-")
                            .compactMap(Int.init)

                        let range = numbers[0]...numbers[1]

                        $0.insert(integersIn: range)
                    })
        }

        private static func ticketValues(from line: String) -> [Int] {
            line.components(separatedBy: ",").compactMap(Int.init)
        }

        private static func parseInput(
        _ input: String
        ) -> (fields: [String: IndexSet], ticket: [Int], allTickets: [[Int]]) {
            let components = input.components(separatedBy: "\n\n")

            guard components.count == 3 else { fatalError() }

            let fields = parseInputLines(components[0], using: field(from:))
                .reduce(into: [:]) { $0[$1.0] = $1.1 }

            let ticket = parseInputLines(components[1],
                                         using: ticketValues(from:))[1]

            let allTickets = parseInputLines(components[2],
                                             using: ticketValues(from:))
                .filter { !$0.isEmpty }

            return (fields, ticket, allTickets)
        }

        private static func ticketScanningErrorRate(
            tickets: [[Int]],
            fields: [String: IndexSet]
        ) -> Int {
            let allValues = tickets.flatMap { $0 }
            let validRanges = fields.values

            let invalidValues = allValues.filter { value in
                !validRanges.contains { range in
                    range.contains(value)
                }
            }

            return invalidValues.sum()
        }

        public static func example1() -> String {
            let (fields, _, tickets) = parseInput(exampleInput)

            let errorRate = ticketScanningErrorRate(tickets: tickets,
                                                    fields: fields)

            return "\(errorRate)"
        }

        public static func part1() -> String {
            let (fields, _, tickets) = parseInput(puzzleInput())

            let errorRate = ticketScanningErrorRate(tickets: tickets,
                                                    fields: fields)

            return "\(errorRate)"
        }

        private static func decodedTicket(
            fields: [String: IndexSet],
            ticket: [Int],
            allTickets: [[Int]]
        ) -> [String: Int] {
            let validTickets = [ticket] + allTickets.filter { ticket in
                ticket.allSatisfy { value in
                    fields.values.contains { range in
                        range.contains(value)
                    }
                }
            }

            var undeterminedFields = Set(fields.keys)
            var decodedFieldPositions = [String?](repeating: nil,
                                                  count: fields.count)

            while decodedFieldPositions.contains(nil) {
                for field in undeterminedFields {
                    guard let rule = fields[field] else { continue }

                    let validIndexes = decodedFieldPositions
                        .enumerated()
                        .filter { $0.1 == nil }
                        .filter { (index, _) in
                            validTickets.map { $0[index] }.allSatisfy {
                                rule.contains($0)
                            }
                        }
                        .map { $0.offset }

                    if validIndexes.count == 1 {
                        decodedFieldPositions[validIndexes[0]] = field
                        undeterminedFields.remove(field)
                    }
                }
            }

            return decodedFieldPositions.enumerated().reduce(into: [:]) {
                if let field = $1.1 {
                    $0[field] = ticket[$1.0]
                }
            }
        }

        public static func part2() -> String {
            let (fields, ticket, allTickets) = parseInput(puzzleInput())

            let decodedTicket = self.decodedTicket(fields: fields,
                                                   ticket: ticket,
                                                   allTickets: allTickets)

            let departureFields = decodedTicket
                .filter { $0.key.hasPrefix("departure") }
                .map { $0.value }

            return "\(departureFields.reduce(1, *))"
        }

    }

}
