//
//  2020Day7.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/7/20.
//

import Foundation

private let exampleInput1 =
    """
    light red bags contain 1 bright white bag, 2 muted yellow bags.
    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
    bright white bags contain 1 shiny gold bag.
    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
    faded blue bags contain no other bags.
    dotted black bags contain no other bags.
    """

private let exampleInput2 =
    """
    shiny gold bags contain 2 dark red bags.
    dark red bags contain 2 dark orange bags.
    dark orange bags contain 2 dark yellow bags.
    dark yellow bags contain 2 dark green bags.
    dark green bags contain 2 dark blue bags.
    dark blue bags contain 2 dark violet bags.
    dark violet bags contain no other bags.
    """

extension Year2020 {

    public enum Day7: FullPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 7

        enum BagContents {
            case bags([String: Int])
            case noOtherBags

            init?(scanner: Scanner) {
                var bags: [String: Int] = [:]
                
                let terminators = CharacterSet(charactersIn: " .")

                while !scanner.isAtEnd {
                    guard let count = scanner.scanInt(),
                          let color = scanner.scanUpToString(" bag"),
                          scanner.scanUpToCharacters(from: terminators) != nil
                          else { break }

                    bags[color] = count
                }

                if bags.isEmpty {
                    self = .noOtherBags
                }
                else {
                    self = .bags(bags)
                }
            }
        }

        private static func parse(
            line: String
        ) -> (outerBagColor: String, contents: BagContents)? {
            let scanner = Scanner(string: line)

            guard let outerColor = scanner.scanUpToString(" bags contain "),
                  scanner.scanString("bags contain ") != nil,
                  let contents = BagContents(scanner: scanner)
            else { return nil }

            return (outerColor, contents)
        }

        private static func bagColor(
            _ bagColor: String,
            eventuallyContains targetColor: String,
            in rules: [String: BagContents]
        ) -> Bool {
            switch rules[bagColor] {
            case let .bags(bags):
                if bags.keys.contains(targetColor) { return true }

                return bags.contains { color, _ in
                    self.bagColor(color,
                                  eventuallyContains: targetColor, 
                                  in: rules)
                }

            default: return false
            }
        }

        private static func bagColorsEventuallyContaining(
            bagColor: String,
            in rules: [String: BagContents]
        ) -> [String] {
            rules.keys.filter {
                self.bagColor($0, eventuallyContains: bagColor, in: rules)
            }
        }

        public static func example1() -> String {
            let rules = parseInputLines(exampleInput1, using: parse(line:))
                .reduce(into: [String: BagContents]()) { $0[$1.0] = $1.1 }

            let colors = bagColorsEventuallyContaining(bagColor: "shiny gold",
                                                       in: rules)

            return "\(colors.count)"
        }

        public static func part1() -> String {
            let rules = parseInputLines(puzzleInput(), using: parse(line:))
                .reduce(into: [String: BagContents]()) { $0[$1.0] = $1.1 }

            let colors = bagColorsEventuallyContaining(bagColor: "shiny gold",
                                                       in: rules)

            return "\(colors.count)"
        }

        private static func bagsRequired(
            insideBagColor bagColor: String,
            using rules: [String: BagContents]
        ) -> Int {
            switch rules[bagColor] {
            case let .bags(bags):
                return bags.reduce(into: 0) {
                    $0 += $1.value
                    $0 += ($1.value * bagsRequired(insideBagColor: $1.key,
                                                   using: rules))
                }

            default: return 0
            }
        }

        public static func example2() -> String {
            let rules = parseInputLines(exampleInput2, using: parse(line:))
                .reduce(into: [String: BagContents]()) { $0[$1.0] = $1.1 }

            let count = bagsRequired(insideBagColor: "shiny gold", using: rules)

            return "\(count)"
        }

        public static func part2() -> String {
            let rules = parseInputLines(puzzleInput(), using: parse(line:))
                .reduce(into: [String: BagContents]()) { $0[$1.0] = $1.1 }

            let count = bagsRequired(insideBagColor: "shiny gold", using: rules)

            return "\(count)"
        }

    }

}
