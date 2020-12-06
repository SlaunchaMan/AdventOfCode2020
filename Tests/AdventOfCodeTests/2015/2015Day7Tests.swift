//
//  2015Day7Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/5/20.
//

import AdventOfCode
import XCTest

class Year2015Day7Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(Year2015.Day7.example1(),
                       """
                        d: 72
                        e: 507
                        f: 492
                        g: 114
                        h: 65412
                        i: 65079
                        x: 123
                        y: 456
                        """)
    }

    func testPart1() {
        XCTAssertEqual(Year2015.Day7.part1(), "956")
    }

    func testPart2() {
        XCTAssertEqual(Year2015.Day7.part2(), "40149")
    }

}
