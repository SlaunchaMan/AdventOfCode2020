//
//  NumericsTests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/11/20.
//

#if DEBUG

@testable import AdventOfCode
import XCTest

class NumericsTests: XCTestCase {

    func testFactoring() {
        XCTAssertEqual(10.factors(), [1, 2, 5, 10])
        XCTAssertEqual(8675309.factors(), [1, 8675309])
    }

    func testFactoringStartingAt() {
        XCTAssertEqual(10.factors(startingAt: 5), [5, 10])
    }

}

#endif
