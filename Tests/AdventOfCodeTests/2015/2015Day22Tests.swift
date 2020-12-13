//
//  2015Day22Tests.swift
//  AdventOfCodeTests
//
//  Created by Jeff Kelley on 12/12/20.
//

import AdventOfCode
import XCTest

class Year2015Day22Tests: XCTestCase {

    func testExample1() {
        XCTAssertEqual(captureLogOutput { _ = Year2015.Day22.example1() },
                       // swiftlint:disable line_length
                       """
                       -- Player turn --
                       - Player has 10 hit points, 0 armor, 250 mana
                       - Boss has 13 hit points
                       Player casts Poison.

                       -- Boss turn --
                       - Player has 10 hit points, 0 armor, 77 mana
                       - Boss has 13 hit points
                       Poison deals 3 damage; its timer is now 5.
                       Boss attacks for 8 damage!

                       -- Player turn --
                       - Player has 2 hit points, 0 armor, 77 mana
                       - Boss has 10 hit points
                       Poison deals 3 damage; its timer is now 4.
                       Player casts Magic Missile, dealing 4 damage.

                       -- Boss turn --
                       - Player has 2 hit points, 0 armor, 24 mana
                       - Boss has 3 hit points
                       Poison deals 3 damage. This kills the boss, and the player wins.
                       """
                       // swiftlint:enable line_length
        )
    }

    // swiftlint:disable:next function_body_length
    func testExample2() {
        XCTAssertEqual(captureLogOutput { _ = Year2015.Day22.example2() },
                       // swiftlint:disable line_length
                       """
                       -- Player turn --
                       - Player has 10 hit points, 0 armor, 250 mana
                       - Boss has 14 hit points
                       Player casts Recharge.

                       -- Boss turn --
                       - Player has 10 hit points, 0 armor, 21 mana
                       - Boss has 14 hit points
                       Recharge provides 101 mana; its timer is now 4.
                       Boss attacks for 8 damage!

                       -- Player turn --
                       - Player has 2 hit points, 0 armor, 122 mana
                       - Boss has 14 hit points
                       Recharge provides 101 mana; its timer is now 3.
                       Player casts Shield, increasing armor by 7.

                       -- Boss turn --
                       - Player has 2 hit points, 7 armor, 110 mana
                       - Boss has 14 hit points
                       Shield's timer is now 5.
                       Recharge provides 101 mana; its timer is now 2.
                       Boss attacks for 8 - 7 = 1 damage!

                       -- Player turn --
                       - Player has 1 hit point, 7 armor, 211 mana
                       - Boss has 14 hit points
                       Shield's timer is now 4.
                       Recharge provides 101 mana; its timer is now 1.
                       Player casts Drain, dealing 2 damage, and healing 2 hit points.

                       -- Boss turn --
                       - Player has 3 hit points, 7 armor, 239 mana
                       - Boss has 12 hit points
                       Shield's timer is now 3.
                       Recharge provides 101 mana; its timer is now 0.
                       Recharge wears off.
                       Boss attacks for 8 - 7 = 1 damage!

                       -- Player turn --
                       - Player has 2 hit points, 7 armor, 340 mana
                       - Boss has 12 hit points
                       Shield's timer is now 2.
                       Player casts Poison.

                       -- Boss turn --
                       - Player has 2 hit points, 7 armor, 167 mana
                       - Boss has 12 hit points
                       Shield's timer is now 1.
                       Poison deals 3 damage; its timer is now 5.
                       Boss attacks for 8 - 7 = 1 damage!

                       -- Player turn --
                       - Player has 1 hit point, 7 armor, 167 mana
                       - Boss has 9 hit points
                       Shield's timer is now 0.
                       Shield wears off, decreasing armor by 7.
                       Poison deals 3 damage; its timer is now 4.
                       Player casts Magic Missile, dealing 4 damage.

                       -- Boss turn --
                       - Player has 1 hit point, 0 armor, 114 mana
                       - Boss has 2 hit points
                       Poison deals 3 damage. This kills the boss, and the player wins.
                       """
                       // swiftlint:enable line_length
        )
    }

    func testPart1() {
        XCTAssertEqual(Year2015.Day22.part1(), "900")
    }

    func testPart2() {
        XCTAssertEqual(Year2015.Day22.part2(), "1216")
    }

}
