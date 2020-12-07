//
//  2015Day9.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/6/20.
//

import Algorithms
import Foundation

private let exampleInput =
    """
    London to Dublin = 464
    London to Belfast = 518
    Dublin to Belfast = 141
    """

extension Year2015 {

    public enum Day9: FullPuzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 9

        struct CityPair: Hashable, Equatable {
            let first: String
            let second: String

            func containsBoth(_ firstCity: String,
                              and secondCity: String) -> Bool {
                Set([first, second]) == Set([firstCity, secondCity])
            }
        }

        private static func distancesAndCities(
            for input: [String]
        ) -> (Set<String>, [CityPair: Int]) {
            input.reduce(into: (Set<String>(), [CityPair: Int]())) {
                let scanner = Scanner(string: $1)

                guard let first = scanner.scanUpToString(" to "),
                      scanner.scanString("to ") != nil,
                      let second = scanner.scanUpToString(" = "),
                      scanner.scanString("= ") != nil,
                      let distance = scanner.scanInt() else {
                    return
                }

                $0.0.insert(first)
                $0.0.insert(second)

                $0.1[CityPair(first: first, second: second)] = distance
            }
        }

        private static func distance<T: Sequence>(
            forRoute route: T,
            distances: [CityPair: Int]
        ) -> Int? where T.Element == String {
            var distance = 0
            var iterator = route.makeIterator()

            guard var firstCity = iterator.next() else { return nil }

            while let nextCity = iterator.next() {
                guard let legDistance = distances.first(where: {
                    $0.0.containsBoth(firstCity, and: nextCity)
                })?.value else { fatalError() }

                distance += legDistance
                firstCity = nextCity
            }

            guard distance > 0 else { return nil }

            return distance
        }

        private static func possibleRouteDistances(for input: String) -> [Int] {
            let (cities, distances) = self.distancesAndCities(
                for: parseInputLines(input)
            )

            let permutations = Array(cities).permutations()

            let routeDistances = permutations.compactMap {
                distance(forRoute: $0, distances: distances)
            }

            return routeDistances
        }

        private static func shortestDistance(for input: String) -> Int {
            return possibleRouteDistances(for: input).min()!
        }

        public static func example1() -> String {
            return "\(shortestDistance(for: exampleInput))"
        }

        public static func part1() -> String {
            return "\(shortestDistance(for: puzzleInput()))"
        }

        private static func longestDistance(for input: String) -> Int {
            return possibleRouteDistances(for: input).max()!
        }

        public static func example2() -> String {
            "\(longestDistance(for: exampleInput))"
        }

        public static func part2() -> String {
            "\(longestDistance(for: puzzleInput()))"
        }

    }

}
