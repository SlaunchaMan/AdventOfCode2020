//
//  2017Day1Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/27/20.
//

import AdventOfCode
import XCTest

class Year2017Day1Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(Year2017.Day1.example1(), "3,4,0,9")
    }

    func testPart1() {
        XCTAssertEqual(Year2017.Day1.part1(), "1177")
    }

    func testExample2() {
        XCTAssertEqual(Year2017.Day1.example2(), "6,0,4,12,4")
    }

    func testPart2() {
        XCTAssertEqual(Year2017.Day1.part2(), "1060")
    }

}
