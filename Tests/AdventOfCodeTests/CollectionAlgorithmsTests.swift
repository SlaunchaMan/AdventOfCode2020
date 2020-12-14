//
//  CollectionAlgorithmsTests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/11/20.
//

#if DEBUG

@testable import AdventOfCode
import XCTest

class DirectionalNeighborsTests: XCTestCase {

    private func parseInputLines(_ input: String) -> [String] {
        input.components(separatedBy: .newlines)
    }

    // MARK: - 2011 Day 11

    func testOneEmptySeat() {
        let input = parseInputLines(
            """
            .......#.
            ...#.....
            .#.......
            .........
            ..#L....#
            ....#....
            .........
            #........
            ...#.....
            """
        )

        let visibleNeighbors = input.firstVisibleNeighbors(
            of: (4, input[4].index(input[4].startIndex, offsetBy: 3)),
            skippingIndexesWhere: { $0 == "." }
        )

        XCTAssertEqual(String(visibleNeighbors.map { input[$0] }),
                       "########")
    }

    func testOnlyOneVisibleSeat() {
        let input = parseInputLines(
            """
            .............
            .L.L.#.#.#.#.
            .............
            """
        )

        let visibleNeighbors = input.firstVisibleNeighbors(
            of: (1, input[1].index(input[1].startIndex, offsetBy: 1)),
            skippingIndexesWhere: { $0 == "." }
        )

        XCTAssertEqual(String(visibleNeighbors.map { input[$0] }),
                       "L")
    }

    func testNoVisibleOccupiedSeats() {
        let input = parseInputLines(
            """
            .##.##.
            #.#.#.#
            ##...##
            ...L...
            ##...##
            #.#.#.#
            .##.##.
            """
        )

        let visibleNeighbors = input.firstVisibleNeighbors(
            of: (3, input[3].index(input[3].startIndex, offsetBy: 3)),
            skippingIndexesWhere: { $0 == "." }
        )

        XCTAssertTrue(visibleNeighbors.isEmpty)
    }

    func testManyOccupiedSeats() {
        let input = parseInputLines(
            """
            #.##.##.##
            #######.##
            #.#.#..#..
            ####.##.##
            #.##.##.##
            #.#####.##
            ..#.#.....
            ##########
            #.######.#
            #.#####.##
            """
        )

        let visibleNeighbors = input.firstVisibleNeighbors(
            of: (2, input[2].index(input[2].startIndex, offsetBy: 7)),
            skippingIndexesWhere: { $0 == "." }
        )

        XCTAssertEqual(String(visibleNeighbors.map { input[$0] }),
                       "######")
    }

    // MARK: -

}

#endif
