//
//  2020Day22Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/22/20.
//

import AdventOfCode
import XCTest

private let example2ExpectedOutput =
    """
    === Game 1 ===

    -- Round 1 (Game 1) --
    Player 1's deck: 9, 2, 6, 3, 1
    Player 2's deck: 5, 8, 4, 7, 10
    Player 1 plays: 9
    Player 2 plays: 5
    Player 1 wins round 1 of game 1!

    -- Round 2 (Game 1) --
    Player 1's deck: 2, 6, 3, 1, 9, 5
    Player 2's deck: 8, 4, 7, 10
    Player 1 plays: 2
    Player 2 plays: 8
    Player 2 wins round 2 of game 1!

    -- Round 3 (Game 1) --
    Player 1's deck: 6, 3, 1, 9, 5
    Player 2's deck: 4, 7, 10, 8, 2
    Player 1 plays: 6
    Player 2 plays: 4
    Player 1 wins round 3 of game 1!

    -- Round 4 (Game 1) --
    Player 1's deck: 3, 1, 9, 5, 6, 4
    Player 2's deck: 7, 10, 8, 2
    Player 1 plays: 3
    Player 2 plays: 7
    Player 2 wins round 4 of game 1!

    -- Round 5 (Game 1) --
    Player 1's deck: 1, 9, 5, 6, 4
    Player 2's deck: 10, 8, 2, 7, 3
    Player 1 plays: 1
    Player 2 plays: 10
    Player 2 wins round 5 of game 1!

    -- Round 6 (Game 1) --
    Player 1's deck: 9, 5, 6, 4
    Player 2's deck: 8, 2, 7, 3, 10, 1
    Player 1 plays: 9
    Player 2 plays: 8
    Player 1 wins round 6 of game 1!

    -- Round 7 (Game 1) --
    Player 1's deck: 5, 6, 4, 9, 8
    Player 2's deck: 2, 7, 3, 10, 1
    Player 1 plays: 5
    Player 2 plays: 2
    Player 1 wins round 7 of game 1!

    -- Round 8 (Game 1) --
    Player 1's deck: 6, 4, 9, 8, 5, 2
    Player 2's deck: 7, 3, 10, 1
    Player 1 plays: 6
    Player 2 plays: 7
    Player 2 wins round 8 of game 1!

    -- Round 9 (Game 1) --
    Player 1's deck: 4, 9, 8, 5, 2
    Player 2's deck: 3, 10, 1, 7, 6
    Player 1 plays: 4
    Player 2 plays: 3
    Playing a sub-game to determine the winner...

    === Game 2 ===

    -- Round 1 (Game 2) --
    Player 1's deck: 9, 8, 5, 2
    Player 2's deck: 10, 1, 7
    Player 1 plays: 9
    Player 2 plays: 10
    Player 2 wins round 1 of game 2!

    -- Round 2 (Game 2) --
    Player 1's deck: 8, 5, 2
    Player 2's deck: 1, 7, 10, 9
    Player 1 plays: 8
    Player 2 plays: 1
    Player 1 wins round 2 of game 2!

    -- Round 3 (Game 2) --
    Player 1's deck: 5, 2, 8, 1
    Player 2's deck: 7, 10, 9
    Player 1 plays: 5
    Player 2 plays: 7
    Player 2 wins round 3 of game 2!

    -- Round 4 (Game 2) --
    Player 1's deck: 2, 8, 1
    Player 2's deck: 10, 9, 7, 5
    Player 1 plays: 2
    Player 2 plays: 10
    Player 2 wins round 4 of game 2!

    -- Round 5 (Game 2) --
    Player 1's deck: 8, 1
    Player 2's deck: 9, 7, 5, 10, 2
    Player 1 plays: 8
    Player 2 plays: 9
    Player 2 wins round 5 of game 2!

    -- Round 6 (Game 2) --
    Player 1's deck: 1
    Player 2's deck: 7, 5, 10, 2, 9, 8
    Player 1 plays: 1
    Player 2 plays: 7
    Player 2 wins round 6 of game 2!
    The winner of game 2 is player 2!

    ...anyway, back to game 1.
    Player 2 wins round 9 of game 1!

    -- Round 10 (Game 1) --
    Player 1's deck: 9, 8, 5, 2
    Player 2's deck: 10, 1, 7, 6, 3, 4
    Player 1 plays: 9
    Player 2 plays: 10
    Player 2 wins round 10 of game 1!

    -- Round 11 (Game 1) --
    Player 1's deck: 8, 5, 2
    Player 2's deck: 1, 7, 6, 3, 4, 10, 9
    Player 1 plays: 8
    Player 2 plays: 1
    Player 1 wins round 11 of game 1!

    -- Round 12 (Game 1) --
    Player 1's deck: 5, 2, 8, 1
    Player 2's deck: 7, 6, 3, 4, 10, 9
    Player 1 plays: 5
    Player 2 plays: 7
    Player 2 wins round 12 of game 1!

    -- Round 13 (Game 1) --
    Player 1's deck: 2, 8, 1
    Player 2's deck: 6, 3, 4, 10, 9, 7, 5
    Player 1 plays: 2
    Player 2 plays: 6
    Playing a sub-game to determine the winner...

    === Game 3 ===

    -- Round 1 (Game 3) --
    Player 1's deck: 8, 1
    Player 2's deck: 3, 4, 10, 9, 7, 5
    Player 1 plays: 8
    Player 2 plays: 3
    Player 1 wins round 1 of game 3!

    -- Round 2 (Game 3) --
    Player 1's deck: 1, 8, 3
    Player 2's deck: 4, 10, 9, 7, 5
    Player 1 plays: 1
    Player 2 plays: 4
    Playing a sub-game to determine the winner...

    === Game 4 ===

    -- Round 1 (Game 4) --
    Player 1's deck: 8
    Player 2's deck: 10, 9, 7, 5
    Player 1 plays: 8
    Player 2 plays: 10
    Player 2 wins round 1 of game 4!
    The winner of game 4 is player 2!

    ...anyway, back to game 3.
    Player 2 wins round 2 of game 3!

    -- Round 3 (Game 3) --
    Player 1's deck: 8, 3
    Player 2's deck: 10, 9, 7, 5, 4, 1
    Player 1 plays: 8
    Player 2 plays: 10
    Player 2 wins round 3 of game 3!

    -- Round 4 (Game 3) --
    Player 1's deck: 3
    Player 2's deck: 9, 7, 5, 4, 1, 10, 8
    Player 1 plays: 3
    Player 2 plays: 9
    Player 2 wins round 4 of game 3!
    The winner of game 3 is player 2!

    ...anyway, back to game 1.
    Player 2 wins round 13 of game 1!

    -- Round 14 (Game 1) --
    Player 1's deck: 8, 1
    Player 2's deck: 3, 4, 10, 9, 7, 5, 6, 2
    Player 1 plays: 8
    Player 2 plays: 3
    Player 1 wins round 14 of game 1!

    -- Round 15 (Game 1) --
    Player 1's deck: 1, 8, 3
    Player 2's deck: 4, 10, 9, 7, 5, 6, 2
    Player 1 plays: 1
    Player 2 plays: 4
    Playing a sub-game to determine the winner...

    === Game 5 ===

    -- Round 1 (Game 5) --
    Player 1's deck: 8
    Player 2's deck: 10, 9, 7, 5
    Player 1 plays: 8
    Player 2 plays: 10
    Player 2 wins round 1 of game 5!
    The winner of game 5 is player 2!

    ...anyway, back to game 1.
    Player 2 wins round 15 of game 1!

    -- Round 16 (Game 1) --
    Player 1's deck: 8, 3
    Player 2's deck: 10, 9, 7, 5, 6, 2, 4, 1
    Player 1 plays: 8
    Player 2 plays: 10
    Player 2 wins round 16 of game 1!

    -- Round 17 (Game 1) --
    Player 1's deck: 3
    Player 2's deck: 9, 7, 5, 6, 2, 4, 1, 10, 8
    Player 1 plays: 3
    Player 2 plays: 9
    Player 2 wins round 17 of game 1!
    The winner of game 1 is player 2!


    == Post-game results ==
    Player 1's deck:
    Player 2's deck: 7, 5, 6, 2, 4, 1, 10, 8, 9, 3
    """

class Year2020Day22Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(Year2020.Day22.example1(), "306")
    }

    func testPart1() {
        XCTAssertEqual(Year2020.Day22.part1(), "30197")
    }

    func testExample2() {
        var score: String = ""

        let output = captureLogOutput { score = Year2020.Day22.example2() }

        XCTAssertEqual(score, "291")
    }

    func testPart2() {
        XCTAssertEqual(Year2020.Day22.part2(), "34031")
    }

}
