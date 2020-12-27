//
//  2015Day12.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/7/20.
//

import Foundation

extension Year2015 {

    public enum Day12: TwoPartPuzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 12

        private static func sum(
            of item: Any,
            removing filter: String? = nil
        ) -> Int {
            if let number = item as? Int {
                return number
            }
            else if let object = item as? [String: Any] {
                return sum(of: object, removing: filter)
            }
            else if let array = item as? [Any] {
                return sum(of: array, removing: filter)
            }
            else {
                return 0
            }
        }

        private static func sum(
            of object: [String: Any],
            removing filter: String? = nil
        ) -> Int {
            if let filter = filter,
               object.values.contains(where: { $0 as? String == filter }) {
                return 0
            }
            else {
                return object.values.sum { sum(of: $0, removing: filter) }
            }
        }

        private static func sum(
            of array: [Any],
            removing filter: String? = nil
        ) -> Int {
            array.sum { sum(of: $0, removing: filter) }
        }

        private static func sum(
            ofJSON json: String,
            removing filter: String? = nil
        ) -> Int {
            let data = Data(json.utf8)

            guard let root = try? JSONSerialization.jsonObject(with: data)
            else { return 0 }

            if let rootObject = root as? [String: Any] {
                return sum(of: rootObject, removing: filter)
            }
            else if let rootArray = root as? [Any] {
                return sum(of: rootArray, removing: filter)
            }
            else {
                return 0
            }
        }

        public static func part1() -> String {
            "\(sum(ofJSON: puzzleInput()))"
        }

        public static func part2() -> String {
            "\(sum(ofJSON: puzzleInput(), removing: "red"))"
        }

    }

}
