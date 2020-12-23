//
//  2016Day17Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/22/20.
//

import AdventOfCode
import XCTest

class Year2016Day17Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(Year2016.Day17.example1(),
                       "DDRRRD,DDUDRLRRUDRD,DRURDRUDDLLDLUURRDULRLDUUDDDRR")
    }

    func testPart1() {
        XCTAssertEqual(Year2016.Day17.part1(), "RDULRDDRRD")
    }

    func testExample2() {
        XCTAssertEqual(Year2016.Day17.example2(), "370,492,830")
    }

    func testPart2() {
        XCTAssertEqual(Year2016.Day17.part2(), "752")
    }

}
