//
//  2016Day11.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/17/20.
//

import Algorithms
import Foundation

// swiftlint:disable line_length
private let exampleInput =
    """
    The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
    The second floor contains a hydrogen generator.
    The third floor contains a lithium generator.
    The fourth floor contains nothing relevant.
    """
// swiftlint:enable line_length

extension Year2016 {

    public enum Day11: PuzzleWithExample1 {

        public static let year: Year.Type = Year2016.self

        public static let day = 11

        enum Item: CustomStringConvertible, Hashable {
            case generator(element: String)
            case microchip(element: String)

            init?(string: String) {
                let components = string.components(
                    separatedBy: CharacterSet(charactersIn: " -")
                )

                if components.last!.hasPrefix("generator") {
                    self = .generator(element: components[0])
                }
                else if components.last!.hasPrefix("microchip") {
                    self = .microchip(element: components[0])
                }
                else {
                    return nil
                }
            }

            var description: String {
                switch self {
                case let .generator(element: element):
                    return element.first!.uppercased() + "G"
                case let .microchip(element: element):
                    return element.first!.uppercased() + "M"
                }
            }

            var element: String {
                switch self {
                case let .generator(element: element),
                     let .microchip(element: element):
                    return element
                }
            }

            var pair: Item {
                switch self {
                case let .generator(element: element):
                    return .microchip(element: element)
                case let .microchip(element: element):
                    return .generator(element: element)
                }
            }
        }

        enum ElevatorPosition: Int {
            case firstFloor = 0
            case secondFloor = 1
            case thirdFloor = 2
            case fourthFloor = 3
        }

        struct TestFacility: Hashable {
            let floorContents: [Set<Item>]
            let elevatorPosition: Int

            init(floorContents: [Set<Item>], elevatorPosition: Int) {
                self.floorContents = floorContents
                self.elevatorPosition = elevatorPosition
            }

            init?(string: String) {
                elevatorPosition = 0

                floorContents = Day11.parseInputLines(string).map { line in
                    line.components(separatedBy: " contains ")[1]
                        .replacingOccurrences(of: " and ", with: ", ")
                        .components(separatedBy: ", ")
                        .map { $0[$0.index($0.startIndex, offsetBy: 2)...] }
                        .map(String.init)
                        .compactMap(Item.init)
                }.map(Set.init)
            }

            var equivalenceDiagram: String {
                (0..<floorContents.count).map { normalizedContents(at: $0) }
                    .joined() + "\(elevatorPosition)"
            }

            func floor(for item: Item) -> Int? {
                floorContents.firstIndex {
                    $0.contains(item)
                }
            }

            var isSolved: Bool {
                floorContents[0...2].allSatisfy(\.isEmpty)
            }

            var isValid: Bool {
                floorContents.allSatisfy { contents in
                    contents.filter {
                        if case .microchip = $0 { return true }
                        return false
                    }
                    .map(\.element)
                    .allSatisfy { element in
                        contents.contains(.generator(element: element)) ||
                            !contents.contains {
                                if case .generator = $0 { return true }
                                return false
                            }
                    }
                }
            }

            func diagram() -> String {
                let allItems = floorContents
                    .reduce(into: Set()) { $0.formUnion($1) }
                    .sorted { $0.description < $1.description }

                return floorContents.indexed().reversed().map { index, items in
                    let floor = "F\(index + 1)"
                    let elevator = elevatorPosition == index ? "E" : "."

                    let itemAbbreviations = allItems.map { item in
                        if items.contains(item) {
                            return item.description
                        }
                        else {
                            return ". "
                        }
                    }.joined(separator: " ")

                    return "\(floor) \(elevator)  \(itemAbbreviations)"
                }.joined(separator: "\n")
            }

            func normalizedContents(at floor: Int) -> String {
                let items = floorContents[floor]

                return items.map { item -> String in
                    if items.contains(item.pair) {
                        return "PP"
                    }
                    else {
                        switch item {
                        case .microchip:
                            let floor = self.floor(for: item.pair)
                            return "\(floor!)M"
                        case .generator:
                            let floor = self.floor(for: item.pair)
                            return "\(floor!)G"
                        }
                    }
                }
                .sorted()
                .joined(separator: ", ")
            }

            func possibleSteps() -> Set<TestFacility> {
                let floorContents = self.floorContents[elevatorPosition]

                let fullPair = Set(floorContents.map(\.element)).filter {
                    floorContents.contains(.generator(element: $0)) &&
                        floorContents.contains(.microchip(element: $0))
                }.first

                var itemsToCarry: Set<Set<Item>> = []

                if floorContents.count > 0 {
                    for item in floorContents { itemsToCarry.insert([item]) }
                }

                if floorContents.count > 1 {
                    floorContents.combinations(ofCount: 2)
                        .filter {
                            fullPair == nil ||
                                $0[0].element != $0[1].element ||
                                $0.map(\.element) == [fullPair, fullPair]
                        }
                        .forEach { itemsToCarry.insert([$0[0], $0[1]]) }
                }

                let elevatorPositions = [-1, 1]
                    .map { elevatorPosition + $0 }
                    .filter { (0 ..< 4).contains($0) }

                let possibilities = product(elevatorPositions, itemsToCarry)

                var possibleSteps: Set<TestFacility> = []

                for (floor, items) in possibilities {
                    var floorContents = self.floorContents

                    let newItems = self.floorContents[floor].union(items)
                    floorContents[floor] = newItems

                    floorContents[self.elevatorPosition] =
                        self.floorContents[self.elevatorPosition]
                        .subtracting(newItems)

                    let facility = TestFacility(floorContents: floorContents,
                                                elevatorPosition: floor)

                    possibleSteps.insert(facility)
                }

                return possibleSteps.filter(\.isValid)
            }
        }

        private static func minIterations(for facility: TestFacility) -> Int {
            var iterations = 0
            var possibilities: Set<TestFacility> = [facility]
            var history: Set<String> = [facility.equivalenceDiagram]

            repeat {
                iterations += 1
                log("Iteration \(iterations)\n")

                var next = Set<TestFacility>()

                possibilities.map {
                    $0.possibleSteps().filter {
                        !history.contains($0.equivalenceDiagram)
                    }
                }.forEach { next.formUnion($0) }

                possibilities = next
                history.formUnion(possibilities.map(\.equivalenceDiagram))
            } while !possibilities.contains(where: \.isSolved)

            log(possibilities.first(where: \.isSolved)!.diagram())

            return iterations
        }

        public static func example1() -> String {
            let facility = TestFacility(string: exampleInput)!
            return "\(minIterations(for: facility))"
        }

        public static func part1() -> String {
            let facility = TestFacility(string: puzzleInput())!
            return "\(minIterations(for: facility))"
        }

        public static func part2() -> String {
            let facility = TestFacility(string: puzzleInput())!

            var floorContents = facility.floorContents
            floorContents[0].insert(.generator(element: "elerium"))
            floorContents[0].insert(.microchip(element: "elerium"))
            floorContents[0].insert(.generator(element: "dilithium"))
            floorContents[0].insert(.microchip(element: "dilithium"))

            let withExtraItems = TestFacility(
                floorContents: floorContents,
                elevatorPosition: 0
            )

            return "\(minIterations(for: withExtraItems))"
        }

    }

}
