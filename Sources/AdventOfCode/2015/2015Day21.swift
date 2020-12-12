//
//  2015Day21.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/12/20.
//

import Algorithms
import Foundation

extension Year2015 {

    public enum Day21: Puzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 21

        struct Item {
            let name: String
            var cost = 0
            var damage = 0
            var armor = 0
        }

        struct PlayStats {
            let hitPoints: Int
            let damage: Int
            let armor: Int

            init(hitPoints: Int, damage: Int, armor: Int) {
                self.hitPoints = hitPoints
                self.damage = damage
                self.armor = armor
            }

            init?(string: String) {
                let scanner = Scanner(string: string)

                guard scanner.scanUpToCharacters(from: .decimalDigits) != nil,
                      let hitPoints = scanner.scanInt(),
                      scanner.scanUpToCharacters(from: .decimalDigits) != nil,
                      let damage = scanner.scanInt(),
                      scanner.scanUpToCharacters(from: .decimalDigits) != nil,
                      let armor = scanner.scanInt()
                else { return nil }

                self.hitPoints = hitPoints
                self.damage = damage
                self.armor = armor
            }
        }

        enum GameResult {
            case playerWon
            case playerLost
        }

        private static func weapons() -> [Item] {
            [Item(name: "Dagger", cost: 8, damage: 4),
             Item(name: "Shortsword", cost: 10, damage: 5),
             Item(name: "Warhammer", cost: 25, damage: 6),
             Item(name: "Longsword", cost: 40, damage: 7),
             Item(name: "Greataxe", cost: 74, damage: 8)]
        }

        private static func armor() -> [Item] {
            [Item(name: "None"),
             Item(name: "Leather", cost: 13, armor: 1),
             Item(name: "Chainmail", cost: 31, armor: 2),
             Item(name: "Splintmail", cost: 53, armor: 3),
             Item(name: "Bandedmail", cost: 75, armor: 4),
             Item(name: "Platemail", cost: 102, armor: 5)]
        }

        private static func rings() -> [Item] {
            [Item(name: "Damage +1", cost: 25, damage: 1),
             Item(name: "Damage +2", cost: 50, damage: 2),
             Item(name: "Damage +3", cost: 100, damage: 3),
             Item(name: "Defense +1", cost: 20, armor: 1),
             Item(name: "Defense +2", cost: 40, armor: 2),
             Item(name: "Defense +3", cost: 80, armor: 3)]
        }

        private static func possibleLoadouts() -> [[Item]] {
            let weaponsAndArmor = product(weapons(), armor())

            let possibleRings = [[]] +
                rings().map { [$0] } +
                Array(rings().combinations(ofCount: 2))

            return product(weaponsAndArmor, possibleRings)
                .map { lhs, rhs -> [Item] in
                    [lhs.0, lhs.1] + rhs
                }
        }

        private static func runGame(playerStats: PlayStats,
                                    enemyStats: PlayStats) -> GameResult {
            var playerHP = playerStats.hitPoints
            var enemyHP = enemyStats.hitPoints

            while true {
                // Player’s turn
                let playerDamage = max(1, playerStats.damage - enemyStats.armor)
                enemyHP -= playerDamage
                // swiftlint:disable:next line_length
                log("The player deals \(playerStats.damage)-\(enemyStats.armor) = \(playerDamage) damage; the boss goes down to \(enemyHP) hit points.")

                if enemyHP <= 0 {
                    return .playerWon
                }

                // Enemy’s turn
                let enemyDamage = max(1, enemyStats.damage - playerStats.armor)
                playerHP -= enemyDamage
                // swiftlint:disable:next line_length
                log("The boss deals \(enemyStats.damage)-\(playerStats.armor) = \(enemyDamage) damage; the player goes down to \(playerHP) hit points.")

                if playerHP <= 0 {
                    return .playerLost
                }
            }
        }

        public static func part1() -> String {
            guard let enemyStats = PlayStats(string: puzzleInput())
            else { fatalError() }

            let cheapestVictory = possibleLoadouts()
                .filter {
                    let playerStats = PlayStats(hitPoints: 100,
                                                damage: $0.sum(\.damage),
                                                armor: $0.sum(\.armor))

                    return runGame(playerStats: playerStats,
                                   enemyStats: enemyStats) == .playerWon
                }
                .min { $0.sum(\.cost) < $1.sum(\.cost) }!

            return "\(cheapestVictory.sum(\.cost))"
        }

        public static func part2() -> String {
            guard let enemyStats = PlayStats(string: puzzleInput())
            else { fatalError() }

            let mostExpensiveLoss = possibleLoadouts()
                .filter {
                    let playerStats = PlayStats(hitPoints: 100,
                                                damage: $0.sum(\.damage),
                                                armor: $0.sum(\.armor))

                    return runGame(playerStats: playerStats,
                                   enemyStats: enemyStats) == .playerLost
                }
                .max { $0.sum(\.cost) < $1.sum(\.cost) }!

            return "\(mostExpensiveLoss.sum(\.cost))"
        }

    }

}
