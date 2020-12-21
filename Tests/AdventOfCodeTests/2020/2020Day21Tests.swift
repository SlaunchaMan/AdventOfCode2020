//
//  2020Day21Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/21/20.
//

import AdventOfCode
import XCTest

class Year2020Day21Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(Year2020.Day21.example1(), "5")
    }

    func testPart1() {
        XCTAssertEqual(Year2020.Day21.part1(), "2436")
    }

    func testExample2() {
        XCTAssertEqual(Year2020.Day21.example2(), "mxmxvkd,sqjhc,fvjkl")
    }

    func testPart2() {
        XCTAssertEqual(Year2020.Day21.part2(),
                       "dhfng,pgblcd,xhkdc,ghlzj,dstct,nqbnmzx,ntggc,znrzgs")
    }

}
