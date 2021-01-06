//
//  2017Day10Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 01/5/21.
//

import AdventOfCode
import XCTest

class Year2017Day10Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(Year2017.Day10.example1(), "12")
    }

    func testPart1() {
        XCTAssertEqual(Year2017.Day10.part1(), "7888")
    }

    func testExample2() {
        XCTAssertEqual(Year2017.Day10.example2(),
                       """
                       a2582a3a0e66e6e86e3812dcb672a272
                       33efeb34ea91902bb2f59c9920caa6cd
                       3efbe78a8d82f29979031a4aa0b16a9d
                       63960835bcdc130f0b66d7ff4f6a5a8e
                       """)
    }

    func testPart2() {
        XCTAssertEqual(Year2017.Day10.part2(),
                       "decdf7d377879877173b7f2fb131cf1b")
    }

}
