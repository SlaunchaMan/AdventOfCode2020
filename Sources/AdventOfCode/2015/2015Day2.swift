//
//  2015Day2.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation

extension Year2015 {

    public enum Day2: Puzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 2

        struct Package {
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
                sideAreas.reduce(0, +) * 2
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
            parseInputLines(puzzleInput()) { line in
                let scanner = Scanner(string: line)

                guard let length = scanner.scanInt(),
                      scanner.scanCharacter() != nil,
                      let width = scanner.scanInt(),
                      scanner.scanCharacter() != nil,
                      let height = scanner.scanInt()
                else { return nil }

                return Package(length: length, width: width, height: height)
            }
        }

        public static func part1() -> String {
            "\(packages.map(\.wrappingPaperRequired).reduce(0, +))"
        }

        public static func part2() -> String {
            "\(packages.map(\.ribbonRequired).reduce(0, +))"
        }

    }

}
