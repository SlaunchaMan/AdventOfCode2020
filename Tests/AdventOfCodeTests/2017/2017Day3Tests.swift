//
//  2017Day3Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/27/20.
//

import AdventOfCode
import XCTest

class Year2017Day3Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(Year2017.Day3.example1(), "0,3,2,31")
    }

    func testPart1() {
        XCTAssertEqual(Year2017.Day3.part1(), "438")
    }

    func testPart2() {
        XCTAssertEqual(Year2017.Day3.part2(), "266330")
    }

}
