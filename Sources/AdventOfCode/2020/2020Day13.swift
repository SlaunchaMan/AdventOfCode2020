//
//  2020Day13.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/13/20.
//

import Algorithms
import Foundation

private let exampleInput =
    """
    939
    7,13,x,x,59,x,31,19
    """

extension Year2020 {

    public enum Day13: Puzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 13

        private static func nextBus(
            in busIDs: [Int],
            after startTime: Int
        ) -> (busID: Int, departureTime: Int) {
            var departureTimes = [Int](repeating: 0, count: busIDs.count)

            while departureTimes.contains(where: { $0 <= startTime }) {
                for (index, busID) in busIDs.indexed()
                where departureTimes[index] < startTime {
                    departureTimes[index] += busID
                }
            }

            let smallestMultiple = departureTimes.min()!

            let index = departureTimes.firstIndex(of: smallestMultiple)!

            return (busIDs[index], departureTimes[index])
        }

        public static func example1() -> String {
            let lines = parseInputLines(exampleInput)
            let startTime = Int(lines[0])!

            let busIDs = lines[1]
                .components(separatedBy: ",")
                .compactMap(Int.init)

            let (busID, departureTime) = nextBus(in: busIDs, after: startTime)

            return "\((departureTime - startTime) * busID)"
        }

        public static func part1() -> String {
            let lines = parseInputLines(puzzleInput())
            let startTime = Int(lines[0])!

            let busIDs = lines[1]
                .components(separatedBy: ",")
                .compactMap(Int.init)

            let (busID, departureTime) = nextBus(in: busIDs, after: startTime)

            return "\((departureTime - startTime) * busID)"
        }

        private static func firstSubsequentDepartureSequence(
            busIDs: [Int?]
        ) -> Int {
            let offsetsAndIDs: [(index: Int, id: Int)] = busIDs.indexed()
                .compactMap { (index, id) -> (Int, Int)? in
                    guard let id = id else { return nil }
                    return (index, id)
                }

            let first = offsetsAndIDs[0]

            var elements: [(index: Int, id: Int)] = [first]

            var step = first.id

            for (index, id) in offsetsAndIDs.dropFirst() {
                let stride = Swift.stride(
                    from: step,
                    through: .max,
                    by: elements.map { $0.1 }.productOfElements()
                )

                elements.append((index, id))

                step = stride.first { s in
                    elements.allSatisfy { element in
                        (s + element.index).isMultiple(of: element.id)
                    }
                }!
            }

            return step
        }

        public static func example2() -> String {
            let lines = parseInputLines(exampleInput)

            let busIDs = lines[1]
                .components(separatedBy: ",")
                .map(Int.init)

            return "\(firstSubsequentDepartureSequence(busIDs: busIDs))"
        }

        public static func part2() -> String {
            let lines = parseInputLines(puzzleInput())

            let busIDs = lines[1]
                .components(separatedBy: ",")
                .map(Int.init)

            return "\(firstSubsequentDepartureSequence(busIDs: busIDs))"
        }

    }

}
