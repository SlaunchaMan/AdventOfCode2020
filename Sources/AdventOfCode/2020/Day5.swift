//
//  Day5.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation

public extension ClosedRange where Bound == Int {

    var lowerHalf: ClosedRange<Bound> {
        lowerBound...(((count / 2) + lowerBound) - 1)
    }
    var upperHalf: ClosedRange<Bound> {
        ((upperBound - (count / 2)) + 1)...upperBound
    }

}

extension Year2020 {

    public enum Day5: PuzzleWithExample1 {

        struct Seat {
            let row: Int
            let col: Int
        }

        public static let year: Year.Type = Year2020.self

        public static let day = 5

        private static func seat(
            forBoardingPass boardingPass: String
        ) -> Seat? {
            guard boardingPass.count == 10 else { return nil }

            let inputStart = boardingPass.startIndex
            let columnStart = boardingPass.index(boardingPass.startIndex,
                                                 offsetBy: 7)
            let inputEnd = boardingPass.endIndex

            var rowRange = 0...127
            var colRange = 0...7

            for character in boardingPass[inputStart..<columnStart] {
                switch character {
                case "B": rowRange = rowRange.upperHalf
                case "F": rowRange = rowRange.lowerHalf
                default: fatalError()
                }
                log("\(character) -> \(rowRange)")
            }

            for character in boardingPass[columnStart..<inputEnd] {
                switch character {
                case "R": colRange = colRange.upperHalf
                case "L": colRange = colRange.lowerHalf
                default: fatalError()
                }
                log("\(character) -> \(colRange)")
            }

            return Seat(row: rowRange.lowerBound, col: colRange.lowerBound)
        }

        private static func seatID(forSeat seat: Seat) -> Int {
            (seat.row * 8) + seat.col
        }

        private static func seatID(
            forBoardingPass boardingPass: String
        ) -> Int {
            guard let seat = seat(forBoardingPass: boardingPass) else {
                return 0
            }

            return seatID(forSeat: seat)
        }

        public static func example1() -> String {
            let exampleInput = "FBFBBFFRLR"
            return "\(seatID(forBoardingPass: exampleInput))"
        }

        public static func part1() -> String {
            let seatIDs = parseInputLines(puzzleInput(),
                                          using: seatID(forBoardingPass:))

            return "\(seatIDs.max()!)"
        }

        public static func part2() -> String {
            let seatIDs = parseInputLines(puzzleInput(),
                                          using: seatID(forBoardingPass:))

            for targetSeatRow in 1...126 {
                for targetSeatCol in 0...7 {
                    let candidate = Seat(row: targetSeatRow, col: targetSeatCol)
                    let candidateID = seatID(forSeat: candidate)

                    if !seatIDs.contains(candidateID) &&
                        seatIDs.contains(candidateID - 1) &&
                        seatIDs.contains(candidateID + 1) {
                        return "\(candidateID)"
                    }
                }
            }

            return ""
        }

    }

}
