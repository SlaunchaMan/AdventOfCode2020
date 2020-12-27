//
//  2015Day25.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/12/20.
//

import Foundation
import StringDecoder

extension Year2015 {

    public enum Day25: Puzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 25

        struct CodeLocation: Hashable, Equatable, Decodable {
            let row: Int
            let column: Int

            static let origin = CodeLocation(row: 0, column: 0)

            func previousLocation() -> CodeLocation {
                if column > 1 {
                    return CodeLocation(row: row + 1, column: column - 1)
                }
                else {
                    return CodeLocation(row: 0, column: row - 1)
                }
            }

            func nextLocation() -> CodeLocation {
                if row > 0 {
                    return CodeLocation(row: row - 1, column: column + 1)
                }
                else {
                    return CodeLocation(row: column + 1, column: 0)
                }
            }
        }

        private static var targetPoint: CodeLocation {
            // swiftlint:disable:next line_length
            let format = "To continue, please consult the code grid in the manual.  Enter the code at row $(row), column $(column)."

            let decoder = StringDecoder(formatString: format)

            do {
                let point = try decoder.decode(CodeLocation.self,
                                               from: puzzleInput())
                return CodeLocation(row: point.row - 1,
                                    column: point.column - 1)
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }

        private static func code(
            at location: CodeLocation,
            startingCode: Int
        ) -> Int {
            var currentLocation: CodeLocation = .origin
            var currentCode = startingCode

            while currentLocation != location {
                currentLocation = currentLocation.nextLocation()

                let (_, remainder) = (currentCode * 252533)
                    .quotientAndRemainder(dividingBy: 33554393)

                currentCode = remainder
            }

           return currentCode
        }

        public static func part1() -> String {
            "\(code(at: targetPoint, startingCode: 20151125))"
        }

    }

}
