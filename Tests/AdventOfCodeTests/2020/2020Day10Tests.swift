//
//  2020Day10Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/9/20.
//

import AdventOfCode
import XCTest

class Year2020Day10Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(Year2020.Day10.example1(), "35")
    }

    func testExample1Part2() {
        XCTAssertEqual(Year2020.Day10.example1Part2(), "220")
    }

    func testPart1() {
        XCTAssertEqual(Year2020.Day10.part1(), "2450")
    }

    func testExample2() {
        XCTAssertEqual(Year2020.Day10.example2(), "8")
    }

    func testExample2Part2() {
        XCTAssertEqual(Year2020.Day10.example2Part2(), "19208")
    }

    func testPart2() {
        XCTAssertEqual(Year2020.Day10.part2(), "32396521357312")
    }

}
