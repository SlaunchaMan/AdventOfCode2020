//
//  2017Day3.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/27/20.
//

import Foundation

extension Year2017 {

    public enum Day3: TwoPartPuzzleWithExample1 {

        public static let year: Year.Type = Year2017.self

        public static let day = 3

        struct SpiralPointIterator<Unit: SignedNumeric>: IteratorProtocol {

            private var lastPoint: Point2D<Unit>?
            private var cycle: Unit = 1
            private var direction: MovementDirection = .right
            private var remainingSteps: Unit = 1
            private var turns = 0

            mutating func next() -> Point2D<Unit>? {
                guard let point = lastPoint else {
                    lastPoint = .origin
                    return lastPoint
                }

                if remainingSteps == 0 {
                    turns += 1

                    if turns == 2 {
                        turns = 0
                        cycle += 1
                    }

                    direction += .left
                    remainingSteps = cycle
                }

                lastPoint = point + direction
                remainingSteps -= 1

                return lastPoint
            }

        }

        public static func example1() -> String {
            var steps: [Point2D<Int16>] = []
            var iterator = SpiralPointIterator<Int16>()

            for _ in 1 ... 1024 {
                steps.append(iterator.next()!)
            }

            return [0, 11, 22, 1023]
                .map { steps[$0] }
                .map { $0.manhattanDistance(to: .origin) }
                .map(String.init)
                .joined(separator: ",")
        }

        public static func part1() -> String {
            var iterator = SpiralPointIterator<Int>()
            var step = iterator.next()!

            for _ in 2 ... Int(puzzleInput())! {
                step = iterator.next()!
            }

            return "\(step.manhattanDistance(to: .origin))"
        }

        public static func part2() -> String {
            let target = Int(puzzleInput())!
            var values: [Point2D<Int>: Int] = [.origin: 1]
            var iterator = SpiralPointIterator<Int>()

            values[iterator.next()!] = 1

            while let nextPoint = iterator.next() {
                let nextValue = nextPoint
                    .neighbors()
                    .compactMap { values[$0] }
                    .sum()

                if nextValue > target {
                    return "\(nextValue)"
                }

                values[nextPoint] = nextValue
            }

            return ""
        }

    }

}
