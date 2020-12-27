//
//  2020Day19.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/19/20.
//

import Algorithms
import Foundation

private let exampleInput1 =
    """
    0: 4 1 5
    1: 2 3 | 3 2
    2: 4 4 | 5 5
    3: 4 5 | 5 4
    4: "a"
    5: "b"

    ababbb
    bababa
    abbbab
    aaabbb
    aaaabbb
    """

private let exampleInput2 =
    """
    42: 9 14 | 10 1
    9: 14 27 | 1 26
    10: 23 14 | 28 1
    1: "a"
    11: 42 31
    5: 1 14 | 15 1
    19: 14 1 | 14 14
    12: 24 14 | 19 1
    16: 15 1 | 14 14
    31: 14 17 | 1 13
    6: 14 14 | 1 14
    2: 1 24 | 14 4
    0: 8 11
    13: 14 3 | 1 12
    15: 1 | 14
    17: 14 2 | 1 7
    23: 25 1 | 22 14
    28: 16 1
    4: 1 1
    20: 14 14 | 1 15
    3: 5 14 | 16 1
    27: 1 6 | 14 18
    14: "b"
    21: 14 1 | 1 14
    25: 1 1 | 1 14
    22: 14 14
    8: 42
    26: 14 22 | 1 20
    18: 15 15
    7: 14 5 | 1 21
    24: 14 1

    abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
    bbabbbbaabaabba
    babbbbaabbbbbabbbbbbaabaaabaaa
    aaabbbbbbaaaabaababaabababbabaaabbababababaaa
    bbbbbbbaaaabbbbaaabbabaaa
    bbbababbbbaaaaaaaabbababaaababaabab
    ababaaaaaabaaab
    ababaaaaabbbaba
    baabbaaaabbaaaababbaababb
    abbbbabbbbaaaababbbbbbaaaababb
    aaaaabbaabaaaaababaa
    aaaabbaaaabbaaa
    aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
    babaaabbbaaabaababbaabababaaab
    aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
    """

extension Year2020 {

    public enum Day19: TwoPartPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 19

        indirect enum Rule: CustomStringConvertible, Equatable {

            case sequence([Int])
            case or([Int], [Int])
            case match(String)

            init?(string: String) {
                var components = string.components(separatedBy: " | ")

                if components.count == 1 {
                    components = string.components(separatedBy: .whitespaces)

                    if components.count == 1, let index = Int(string) {
                        self = .sequence([index])
                    }
                    else if components.count == 1 {
                        self = .match(
                            string.trimmingCharacters(
                                in: .punctuationCharacters
                            )
                        )
                    }
                    else {
                        let rules = string
                            .components(separatedBy: .whitespaces)
                            .compactMap(Int.init)

                        self = .sequence(rules)
                    }
                }
                else if components.count == 2 {
                    let lhs = components[0]
                        .components(separatedBy: .whitespaces)
                        .compactMap(Int.init)

                    let rhs = components[1]
                        .components(separatedBy: .whitespaces)
                        .compactMap(Int.init)

                    self = .or(lhs, rhs)
                }
                else {
                    return nil
                }
            }

            var description: String {
                switch self {
                case let .match(string):
                    return #""\#(string)""#

                case let .sequence(rules):
                    return rules
                        .map(String.init)
                        .joined(separator: " ")

                case let .or(lhs, rhs):
                    let lhs = lhs.map(String.init).joined()
                    let rhs = rhs.map(String.init).joined()

                    return "\(lhs) | \(rhs)"
                }
            }

        }

        private static func parse(input: String) -> ([Int: Rule], [String]) {
            let components = input.components(separatedBy: "\n\n")

            let rules: [Int: Rule] = components[0]
                .components(separatedBy: .newlines)
                .reduce(into: [:]) { rules, line in
                    let components = line.components(separatedBy: ": ")

                    rules[Int(components[0])!] = Rule(string: components[1])
                }

            return (rules, components[1].components(separatedBy: .newlines))
        }

        private static func formatted(rules: [Int: Rule]) -> String {
            rules
                .sorted { $0.key < $1.key }
                .map { "\($0.key): \($0.value.description)"}
                .joined(separator: "\n")
        }

        private static func patternString(atIndex index: Int,
                                          in rules: [Int: Rule]) -> String? {
            let transform: (Int) -> String? = {
                patternString(atIndex: $0, in: rules)
            }

            switch rules[index] {
            case .match(let string): return string
            case .sequence(let sequence):
                var matches: [String] = []

                if sequence.allMap(into: &matches, transform) {
                    return matches.joined()
                }
                else {
                    return nil
                }

            case .or(let lhs, let rhs):
                if lhs.count == 2, rhs == [lhs[0], index, lhs[1]],
                   let format0 = patternString(atIndex: lhs[0], in: rules),
                   let format1 = patternString(atIndex: lhs[1], in: rules) {

                    var formats: [String] = []

                    for i in 1...5 {
                        let repeated0 = String(repeating: format0, count: i)
                        let repeated1 = String(repeating: format1, count: i)

                        formats.append(repeated0 + repeated1)
                    }

                    let format = formats.joined(separator: "|")

                    return "(\(format))"
                }
                else if lhs.count == 1, rhs == [lhs[0], index],
                        let format = patternString(atIndex: lhs[0], in: rules) {
                    return "(\(format))+"
                }
                else {
                    var lhsS: [String] = []
                    var rhsS: [String] = []

                    if lhs.allMap(into: &lhsS, transform),
                       rhs.allMap(into: &rhsS, transform) {
                        let or = "\(lhsS.joined())|\(rhsS.joined())"
                        return "(\(or))"
                    }
                    else {
                        return nil
                    }
                }

            default: return nil
            }
        }

        private static func regex(
            for rules: [Int: Rule]
        ) -> NSRegularExpression {
            do {
                return try NSRegularExpression(
                    pattern: "^\(patternString(atIndex: 0, in: rules)!)$",
                    options: [])
            }
            catch {
                log(error)
                fatalError()
            }
        }

        private static func numberOfMatches(strings: [String],
                                            rules: [Int: Rule]) -> Int {
            let regex = self.regex(for: rules)

            return strings.count {
                regex.numberOfMatches(
                    in: $0,
                    options: [.withTransparentBounds],
                    range: NSRange(
                        location: 0,
                        length: $0.utf16.count
                    )
                ) > 0
            }
        }

        public static func example1() -> String {
            let (rules, strings) = parse(input: exampleInput1)
            return "\(numberOfMatches(strings: strings, rules: rules))"
        }

        public static func part1() -> String {
            let (rules, strings) = parse(input: puzzleInput())
            return "\(numberOfMatches(strings: strings, rules: rules))"
        }

        public static func example2() -> String {
            var (rules, strings) = parse(input: exampleInput2)
            rules[8] = .or([42], [42, 8])
            rules[11] = .or([42, 31], [42, 11, 31])

            return "\(numberOfMatches(strings: strings, rules: rules))"
        }

        public static func part2() -> String {
            var (rules, strings) = parse(input: puzzleInput())
            rules[8] = .or([42], [42, 8])
            rules[11] = .or([42, 31], [42, 11, 31])

            return "\(numberOfMatches(strings: strings, rules: rules))"
        }

    }

}
