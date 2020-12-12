//
//  2015Day20Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/11/20.
//

import AdventOfCode
import XCTest

class Year2015Day20Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(Year2015.Day20.example1(),
                       """
                       House 1 got 10 presents.
                       House 2 got 30 presents.
                       House 3 got 40 presents.
                       House 4 got 70 presents.
                       House 5 got 60 presents.
                       House 6 got 120 presents.
                       House 7 got 80 presents.
                       House 8 got 150 presents.
                       House 9 got 130 presents.
                       """)
    }

    func testPart1() {
        XCTAssertEqual(Year2015.Day20.part1(), "665280")
    }

    func testPart2() {
        XCTAssertEqual(Year2015.Day20.part2(), "705600")
    }

}
