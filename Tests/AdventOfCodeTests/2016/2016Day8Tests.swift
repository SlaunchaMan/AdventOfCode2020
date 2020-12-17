//
//  2016Day8Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/16/20.
//

import AdventOfCode
import XCTest

class Year2016Day8Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(Year2016.Day8.example1(),
                       """
                       .#..#.#
                       #.#....
                       .#.....
                       """)
    }

    func testPart1() {
        XCTAssertEqual(Year2016.Day8.part1(), "106")
    }

    func testPart2() {
        XCTAssertEqual(
            Year2016.Day8.part2(),
            """
            .##..####.#....####.#.....##..#...#####..##...###.
            #..#.#....#....#....#....#..#.#...##....#..#.#....
            #....###..#....###..#....#..#..#.#.###..#....#....
            #....#....#....#....#....#..#...#..#....#.....##..
            #..#.#....#....#....#....#..#...#..#....#..#....#.
            .##..#....####.####.####..##....#..#.....##..###..
            """
        )
    }

}
