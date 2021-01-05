//
//  2017Day9Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 01/4/21.
//

import AdventOfCode
import XCTest

class Year2017Day9Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(Year2017.Day9.example1(), "1,6,5,16,1,9,9,3")
    }

    func testPart1() {
        XCTAssertEqual(Year2017.Day9.part1(), "11898")
    }

    func testExample2() {
        XCTAssertEqual(Year2017.Day9.example2(), "0,17,3,2,0,0,10")
    }

    func testPart2() {
        XCTAssertEqual(Year2017.Day9.part2(), "5601")
    }

}
