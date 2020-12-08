//
//  2015Day14.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/7/20.
//

import Foundation
import StringDecoder

private let exampleInput =
    """
    Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
    Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
    """

extension Year2015 {

    public enum Day14: FullPuzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 14

        struct Reindeer: Decodable {
            let name: String
            let speed: Int
            let sprintDuration: Int
            let restDuration: Int

            func position(after second: Int) -> Int {
                var distance = 0
                var timeRemaining = second

                while timeRemaining > 0 {
                    let secondsToRun = min(timeRemaining, sprintDuration)
                    distance += secondsToRun * speed
                    timeRemaining -= secondsToRun
                    timeRemaining -= restDuration
                }

                return distance
            }
        }

        enum ReindeerState {
            case running(speed: Int, remainingDuration: Int)
            case resting(remainingDuration: Int)
        }

        private static func parseReindeer(from input: String) -> Reindeer? {
            // swiftlint:disable:next line_length
            let decoder = StringDecoder(formatString: "$(name) can fly $(speed) km\\/s for $(sprintDuration) seconds, but then must rest for $(restDuration) seconds\\.")

            do {
                return try decoder.decode(Reindeer.self, from: input)
            }
            catch {
                print(error)
                return nil
            }
        }

        public static func example1() -> String {
            let reindeer = parseInputLines(exampleInput,
                                           using: parseReindeer(from:))

            let finalDistances = reindeer.map { $0.position(after: 1000) }

            return "\(finalDistances.max()!)"
        }

        public static func part1() -> String {
            let reindeer = parseInputLines(puzzleInput(),
                                           using: parseReindeer(from:))

            let finalDistances = reindeer.map { $0.position(after: 2503) }

            return "\(finalDistances.max()!)"
        }

        private static func scores(
            after duration: Int,
            reindeer: [Reindeer]
        ) -> [String: Int] {
            var reindeerStates = reindeer.reduce(into: [:]) {
                $0[$1.name] = ReindeerState.running(
                    speed: $1.speed,
                    remainingDuration: $1.sprintDuration
                )
            }

            var distances = reindeer.reduce(into: [:]) {
                $0[$1.name] = 0
            }

            var scores: [String: Int] = [:]

            var time = 0

            while time < duration {
                time += 1

                reindeer.forEach {
                    switch reindeerStates[$0.name] {
                    case let .running(speed, remaining):
                        distances[$0.name, default: 0] += speed
                        if remaining > 1 {
                            reindeerStates[$0.name] = .running(
                                speed: speed,
                                remainingDuration: remaining - 1
                            )
                        }
                        else {
                            reindeerStates[$0.name] = .resting(
                                remainingDuration: $0.restDuration
                            )
                        }

                    case let .resting(remaining):
                        if remaining > 1 {
                            reindeerStates[$0.name] = .resting(
                                remainingDuration: remaining - 1
                            )
                        }
                        else {
                            reindeerStates[$0.name] = .running(
                                speed: $0.speed,
                                remainingDuration: $0.sprintDuration
                            )
                        }

                    default: break
                    }
                }

                if let winningDistance = distances.values.max() {
                    distances
                        .filter { $0.value == winningDistance }
                        .map { $0.key }
                        .forEach { scores[$0, default: 0] += 1 }
                }
            }

            return scores
        }

        public static func example2() -> String {
            let reindeer = parseInputLines(exampleInput,
                                           using: parseReindeer(from:))

            let finalScores = scores(after: 1000, reindeer: reindeer)

            let winner = finalScores.max { (lhs, rhs) -> Bool in
                lhs.value < rhs.value
            }?.value

            return "\(winner!)"
        }

        public static func part2() -> String {
            let reindeer = parseInputLines(puzzleInput(),
                                           using: parseReindeer(from:))

            let finalScores = scores(after: 2503, reindeer: reindeer)

            let winner = finalScores.max { (lhs, rhs) -> Bool in
                lhs.value < rhs.value
            }?.value

            return "\(winner!)"
        }

    }

}
