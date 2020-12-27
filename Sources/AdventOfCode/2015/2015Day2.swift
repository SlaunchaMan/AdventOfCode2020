//
//  2015Day2.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation
import StringDecoder

extension Year2015 {

    public enum Day2: TwoPartPuzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 2

        struct Package: Decodable {
            let length: Int
            let width: Int
            let height: Int

            var perimeters: [Int] {
                [(length + width) * 2,
                 (width + height) * 2,
                 (height + length) * 2]
            }

            var ribbonRequired: Int {
                perimeters.min()! + volume
            }

            var surfaceArea: Int {
                sideAreas.sum() * 2
            }

            var sideAreas: [Int] {
                [length * width, width * height, height * length]
            }

            var volume: Int {
                length * width * height
            }

            var wrappingPaperRequired: Int {
                surfaceArea + sideAreas.min()!
            }

        }

        private static var packages: [Package] {
            let decoder = StringDecoder(
                formatString: "$(length)x$(width)x$(height)"
            )

            return parseInputLines(puzzleInput()) {
                try? decoder.decode(Package.self, from: $0)
            }
        }

        public static func part1() -> String {
            "\(packages.sum(\.wrappingPaperRequired))"
        }

        public static func part2() -> String {
            "\(packages.sum(\.ribbonRequired))"
        }

    }

}
