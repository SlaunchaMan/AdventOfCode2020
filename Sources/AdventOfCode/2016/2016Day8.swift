//
//  2016Day8.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/16/20.
//

import Algorithms
import Foundation

private let exampleInput =
    """
    rect 3x2
    rotate column x=1 by 1
    rotate row y=0 by 4
    rotate column x=1 by 1
    """

extension Year2016 {

    public enum Day8: PuzzleWithExample1 {

        public static let year: Year.Type = Year2016.self

        public static let day = 8

        enum Instruction {
            case rect(width: Int, height: Int)
            case rotateRow(row: Int, offset: Int)
            case rotateColumn(column: Int, offset: Int)

            init?(string: String) {
                let scanner = Scanner(string: string)

                if string.hasPrefix("rect"),
                   scanner.scanString("rect ") != nil,
                   let width = scanner.scanInt(),
                   scanner.scanString("x") != nil,
                   let height = scanner.scanInt() {
                    self = .rect(width: width, height: height)
                }
                else if string.hasPrefix("rotate row"),
                        scanner.scanString("rotate row y=") != nil,
                        let row = scanner.scanInt(),
                        scanner.scanString("by ") != nil,
                        let offset = scanner.scanInt() {
                    self = .rotateRow(row: row, offset: offset)
                }
                else if string.hasPrefix("rotate column"),
                        scanner.scanString("rotate column x=") != nil,
                        let column = scanner.scanInt(),
                        scanner.scanString("by ") != nil,
                        let offset = scanner.scanInt() {
                    self = .rotateColumn(column: column, offset: offset)
                }
                else {
                    return nil
                }
            }
        }

        static func apply(
            instruction: Instruction,
            to grid: [[Bool]]
        ) -> [[Bool]] {
            var grid = grid

            switch instruction {
            case let .rect(width, height):
                for (row, column) in product(0 ..< height, 0 ..< width) {
                    grid[row][column] = true
                }

            case let .rotateRow(row, offset):
                grid[row].rotate(toStartAt: grid[row].count - offset)

            case let .rotateColumn(column, offset):
                for _ in 0 ..< offset {
                    let bottom = grid[grid.count - 1][column]

                    for row in (1 ..< grid.count).reversed() {
                        grid[row][column] = grid[row - 1][column]
                    }

                    grid[0][column] = bottom
                }
            }

            return grid
        }

        private static func finalGrid(
            applying instructions: [Instruction],
            initialGrid: [[Bool]]
        ) -> [[Bool]] {
            var grid = initialGrid

            for instruction in instructions {
                grid = apply(instruction: instruction, to: grid)
            }

            return grid
        }

        private static func grid(width: Int, height: Int) -> [[Bool]] {
            [[Bool]](repeating: [Bool](repeating: false, count: width),
                     count: height)
        }

        private static func description(forGrid grid: [[Bool]]) -> String {
            grid.map { $0.map { $0 ? "#" : "." }.joined() }
                .joined(separator: "\n")
        }

        public static func example1() -> String {
            let grid = self.grid(width: 7, height: 3)

            let instructions = parseInputLines(exampleInput,
                                               using: Instruction.init)

            let finalGrid = self.finalGrid(applying: instructions,
                                           initialGrid: grid)

            return description(forGrid: finalGrid)
        }

        public static func part1() -> String {
            let grid = [[Bool]](repeating: [Bool](repeating: false, count: 50),
                                count: 6)

            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            let finalGrid = self.finalGrid(applying: instructions,
                                           initialGrid: grid)

            return "\(finalGrid.sum { $0.count(of: true) })"
        }

        public static func part2() -> String {
            let grid = [[Bool]](repeating: [Bool](repeating: false, count: 50),
                                count: 6)

            let instructions = parseInputLines(puzzleInput(),
                                               using: Instruction.init)

            let finalGrid = self.finalGrid(applying: instructions,
                                           initialGrid: grid)

            return "\(description(forGrid: finalGrid))"
        }

    }

}
