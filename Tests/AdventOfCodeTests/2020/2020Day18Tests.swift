//
//  2020Day18Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/18/20.
//

import AdventOfCode
import XCTest

class Year2020Day18Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(
            Year2020.Day18.example1(),
            """
            1 + (2 * 3) + (4 * (5 + 6)) becomes 51.
            2 * 3 + (4 * 5) becomes 26.
            5 + (8 * 3 + 9 + 3 * 4 * 3) becomes 437.
            5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) becomes 12240.
            ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 13632.
            """
        )
    }

    func testPart1() {
        XCTAssertEqual(Year2020.Day18.part1(), "6640667297513")
    }

    func testExample2() {
        XCTAssertEqual(
            Year2020.Day18.example2(),
            """
            1 + (2 * 3) + (4 * (5 + 6)) becomes 51.
            2 * 3 + (4 * 5) becomes 46.
            5 + (8 * 3 + 9 + 3 * 4 * 3) becomes 1445.
            5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) becomes 669060.
            ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 23340.
            """
        )
    }

    func testPart2() {
        XCTAssertEqual(Year2020.Day18.part2(), "451589894841552")
    }

}
