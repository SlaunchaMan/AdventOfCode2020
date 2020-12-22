//
//  2016Day16Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/22/20.
//

import AdventOfCode
import XCTest

class Year2016Day16Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(Year2016.Day16.example1(), "01100")
    }

    func testPart1() {
        XCTAssertEqual(Year2016.Day16.part1(), "11100110111101110")
    }

    func testPart2() {
        XCTAssertEqual(Year2016.Day16.part2(), "10001101010000101")
    }

}
