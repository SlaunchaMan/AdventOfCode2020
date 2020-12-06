//
//  2015Day6.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation

extension Year2015 {

    public enum Day6: Puzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 6

        enum Instruction {
            case turnOn(from: Point<Int>, to: Point<Int>)
            case turnOff(from: Point<Int>, to: Point<Int>)
            case toggle(from: Point<Int>, to: Point<Int>)

            init?(string: String) {
                let scanner = Scanner(string: string)

                guard let prefix = scanner
                        .scanUpToCharacters(from: .decimalDigits)
                else { return nil }

                guard let startX = scanner.scanInt(),
                      scanner.scanCharacter() != nil,
                      let startY = scanner.scanInt(),
                      scanner.scanUpToCharacters(from: .decimalDigits) != nil,
                      let endX = scanner.scanInt(),
                      scanner.scanCharacter() != nil,
                      let endY = scanner.scanInt()
                else { return nil }

                let startPoint = Point(x: startX, y: startY)
                let endPoint = Point(x: endX, y: endY)

                switch prefix {
                case "turn on ":
                    self = .turnOn(from: startPoint, to: endPoint)
                case "turn off ":
                    self = .turnOff(from: startPoint, to: endPoint)
                case "toggle ":
                    self = .toggle(from: startPoint, to: endPoint)
                default:
                    return nil
                }
            }

            var startPoint: Point<Int> {
                switch self {
                case .turnOn(from: let point, to: _),
                     .turnOff(from: let point, to: _),
                     .toggle(from: let point, to: _):
                    return point
                }
            }

            var endPoint: Point<Int> {
                switch self {
                case .turnOn(from: _, to: let point),
                     .turnOff(from: _, to: let point),
                     .toggle(from: _, to: let point):
                    return point
                }
            }
        }

        private static var instructions: [Instruction] {
            parseInputLines(puzzleInput(), using: Instruction.init(string:))
        }

        public static func part1() -> String {
            var lights = [[Bool]](
                repeating: [Bool](repeating: false, count: 1000),
                count: 1000
            )

            for instruction in instructions {
                switch instruction {
                case let .turnOn(from: startPoint, to: endPoint):
                    let xRange = startPoint.x...endPoint.x
                    let yRange = startPoint.y...endPoint.y
                    for x in xRange {
                        lights[x].replaceSubrange(
                            yRange,
                            with: [Bool](repeating: true, count: yRange.count)
                        )
                    }
                case let .turnOff(from: startPoint, to: endPoint):
                    let xRange = startPoint.x...endPoint.x
                    let yRange = startPoint.y...endPoint.y
                    for x in xRange {
                        lights[x].replaceSubrange(
                            yRange,
                            with: [Bool](repeating: false, count: yRange.count)
                        )
                    }
                case let .toggle(from: startPoint, to: endPoint):
                    for x in startPoint.x...endPoint.x {
                        for y in startPoint.y...endPoint.y {
                            lights[x][y].toggle()
                        }
                    }
                }
            }

            let numberOfActiveLights = lights
                .flatMap({ $0 })
                .filter { $0 }
                .count

            return "\(numberOfActiveLights)"
        }

        public static func part2() -> String {
            var lights = [[Int]](
                repeating: [Int](repeating: 0, count: 1000),
                count: 1000
            )

            for instruction in instructions {
                for x in instruction.startPoint.x...instruction.endPoint.x {
                    for y in instruction.startPoint.y...instruction.endPoint.y {
                        switch instruction {
                        case .turnOn: lights[x][y] += 1
                        case .turnOff: lights[x][y] = max(0, lights[x][y] - 1)
                        case .toggle: lights[x][y] += 2
                        }
                    }
                }
            }

            let totalBrightness = lights
                .flatMap { $0 }
                .reduce(0, +)

            return "\(totalBrightness)"
        }

    }

}
