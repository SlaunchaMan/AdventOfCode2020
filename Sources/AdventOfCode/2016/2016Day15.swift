//
//  2016Day15.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/21/20.
//

import Foundation
import StringDecoder

private let exampleInput =
    """
    Disc #1 has 5 positions; at time=0, it is at position 4.
    Disc #2 has 2 positions; at time=0, it is at position 1.
    """

extension Year2016 {

    public enum Day15: PuzzleWithExample1 {

        public static let year: Year.Type = Year2016.self

        public static let day = 15

        struct Disc: Decodable {
            let id: Int
            let positions: Int
            let initialPosition: Int

            func position(at time: Int) -> Int {
                (initialPosition + time) % positions
            }
        }

        private static let discDecoder = StringDecoder(
            formatString: "Disc \\#$(id) has $(positions) positions; " +
                "at time\\=0, it is at position $(initialPosition)."
        )

        private static func firstSuccessfulTime(for discs: [Disc]) -> Int? {
            (0 ... .max).first { time in
                discs.allSatisfy { disc in
                    disc.position(at: time + (disc.id)) == 0
                }
            }
        }

        public static func example1() -> String {
            let discs = parseInputLines(exampleInput) { line -> Disc? in
                do {
                    return try discDecoder.decode(Disc.self, from: line)
                }
                catch {
                    log(error)
                    return nil
                }
            }

            return "\(firstSuccessfulTime(for: discs)!)"
        }

        public static func part1() -> String {
            let discs = parseInputLines(puzzleInput()) { line -> Disc? in
                do {
                    return try discDecoder.decode(Disc.self, from: line)
                }
                catch {
                    log(error)
                    return nil
                }
            }

            return "\(firstSuccessfulTime(for: discs)!)"
        }

        public static func part2() -> String {
            var discs = parseInputLines(puzzleInput()) { line -> Disc? in
                do {
                    return try discDecoder.decode(Disc.self, from: line)
                }
                catch {
                    log(error)
                    return nil
                }
            }

            discs.append((Disc(id: discs.count + 1,
                               positions: 11,
                               initialPosition: 0)))

            return "\(firstSuccessfulTime(for: discs)!)"
        }

    }

}
