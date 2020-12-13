//
//  2015Day22.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/12/20.
//

import Algorithms
import Foundation

extension Year2015 {

    public enum Day22: FullPuzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 22

        struct WizardStats {
            var hitPoints: Int
            var mana: Int
            var armor: Int = 0
        }

        enum Spell: CaseIterable {
            case magicMissile
            case drain
            case shield
            case poison
            case recharge

            var manaCost: Int {
                switch self {
                case .magicMissile: return 53
                case .drain: return 73
                case .shield: return 113
                case .poison: return 173
                case .recharge: return 229
                }
            }

            var name: String {
                switch self {
                case .magicMissile: return "Magic Missile"
                case .drain: return "Drain"
                case .shield: return "Shield"
                case .poison: return "Poison"
                case .recharge: return "Recharge"
                }
            }
        }

        struct EnemyStats {
            var hitPoints: Int
            var damage: Int

            init(hitPoints: Int, damage: Int) {
                self.hitPoints = hitPoints
                self.damage = damage
            }

            init?(string: String) {
                let scanner = Scanner(string: string)

                guard scanner.scanUpToCharacters(from: .decimalDigits) != nil,
                      let hitPoints = scanner.scanInt(),
                      scanner.scanUpToCharacters(from: .decimalDigits) != nil,
                      let damage = scanner.scanInt()
                else { return nil }

                self.hitPoints = hitPoints
                self.damage = damage
            }

        }

        enum GameResult {
            case playerWon
            case playerLost
        }

        struct GameState {
            var player: WizardStats
            var enemy: EnemyStats

            var effects: [(Spell, Int)] = []
            var spentMana = 0

            var formattedEnemyHitPoints: String {
                var points = "\(enemy.hitPoints) hit point"

                if enemy.hitPoints > 1 {
                    points.append("s")
                }

                return points
            }

            var formattedPlayerHitPoints: String {
                var points = "\(player.hitPoints) hit point"

                if player.hitPoints > 1 {
                    points.append("s")
                }

                return points
            }

            var playerArmor: Int {
                if effects.contains(where: { $0.0 == .shield }) {
                    return 7
                }
                else {
                    return 0
                }
            }

            func playerCanCast(_ spell: Spell) -> Bool {
                guard player.mana >= spell.manaCost else { return false }
                return !effects.contains { $0.0 == spell }
            }
        }

        private static func processEffects(
            state: GameState
        ) -> (GameState, GameResult?) {
            var state = state

            for (spell, timer) in state.effects {
                switch spell {
                case .poison:
                    if state.enemy.hitPoints <= 3 {
                        // swiftlint:disable:next line_length
                        log("\(spell.name) deals 3 damage. This kills the boss, and the player wins.")
                        state.enemy.hitPoints = 0
                        return (state, .playerWon)
                    }
                    else {
                        state.enemy.hitPoints -= 3
                    }

                case .recharge:
                    state.player.mana += 101

                default: break
                }

                let effectString: String

                switch spell {
                case .recharge: effectString = " provides 101 mana; its"
                case .poison: effectString = " deals 3 damage; its"
                default: effectString = "'s"
                }

                let newTimer = timer - 1
                log("\(spell.name)\(effectString) timer is now \(newTimer).")

                if newTimer == 0 {
                    state.effects.removeAll { $0.0 == spell }
                    if spell == .shield {
                        log("\(spell.name) wears off, decreasing armor by 7.")
                    }
                    else {
                        log("\(spell.name) wears off.")
                    }
                }
                else {
                    let index = state.effects.firstIndex { $0.0 == spell }!
                    state.effects.remove(at: index)
                    state.effects.insert((spell, newTimer), at: index)
                }
            }

            return (state, nil)
        }

        private static func processSpell(
            _ spell: Spell,
            state: GameState
        ) -> (GameState, GameResult?) {
            var state = state

            // You can’t cast the spell. Marking it as a loss to assist with
            // solving algorithm.
            guard state.player.mana >= spell.manaCost,
                  !state.effects.contains(where: { $0.0 == spell })
            else { return (state, .playerLost) }

            state.player.mana -= spell.manaCost
            state.spentMana += spell.manaCost

            switch spell {
            case .magicMissile:
                state.enemy.hitPoints -= 4

                if state.enemy.hitPoints <= 0 {
                    // swiftlint:disable:next line_length
                    log("Player casts \(spell.name), dealing 4 damage. This kills the boss, and the player wins.")

                    return (state, .playerWon)
                }
                else {
                    log("Player casts \(spell.name), dealing 4 damage.")
                }

            case .drain:
                state.enemy.hitPoints -= 2
                state.player.hitPoints += 2

                if state.enemy.hitPoints <= 0 {
                    // swiftlint:disable:next line_length
                    log("Player casts \(spell.name), dealing 2 damage, and healing 2 hit points.  This kills the boss, and the player wins.")

                    return (state, .playerWon)
                }
                else {
                    // swiftlint:disable:next line_length
                    log("Player casts \(spell.name), dealing 2 damage, and healing 2 hit points.")
                }

            case .shield:
                state.effects.insert((spell, 6), at: state.effects.startIndex)
                log("Player casts \(spell.name), increasing armor by 7.")

            case .poison:
                state.effects.append((spell, 6))
                log("Player casts \(spell.name).")

            case .recharge:
                state.effects.append((spell, 5))
                log("Player casts \(spell.name).")
            }

            return (state, nil)
        }

        private static func playTurn(
            gameState state: GameState,
            casting spell: Spell,
            isHardDifficulty: Bool = false
        ) -> (GameState, GameResult?) {
            var state = state

            while true {
                log("-- Player turn --")
                if isHardDifficulty {
                    state.player.hitPoints -= 1
                }

                if state.player.hitPoints <= 0 {
                    return (state, .playerLost)
                }

                // swiftlint:disable:next line_length
                log("- Player has \(state.formattedPlayerHitPoints), \(state.playerArmor) armor, \(state.player.mana) mana")
                log("- Boss has \(state.formattedEnemyHitPoints)")

                var (newState, result) = processEffects(state: state)
                if result != nil { return (newState, result) }
                else { state = newState }

                (newState, result) = processSpell(spell, state: state)
                if result != nil { return (newState, result) }
                else { state = newState }

                log("\n-- Boss turn --")
                // swiftlint:disable:next line_length
                log("- Player has \(state.formattedPlayerHitPoints), \(state.playerArmor) armor, \(state.player.mana) mana")
                log("- Boss has \(state.formattedEnemyHitPoints)")

                (newState, result) = processEffects(state: state)
                if result != nil { return (newState, result) }
                else { state = newState }

                if state.playerArmor > 0 {
                    let damage = max(1, state.enemy.damage - state.playerArmor)

                    state.player.hitPoints -= damage
                    // swiftlint:disable:next line_length
                    log("Boss attacks for \(state.enemy.damage) - \(state.playerArmor) = \(damage) damage!\n")
                }
                else {
                    state.player.hitPoints -= state.enemy.damage
                    log("Boss attacks for \(state.enemy.damage) damage!\n")
                }

                if state.player.hitPoints <= 0 {
                    return (state, .playerLost)
                }

                return (state, nil)
            }
        }

        public static func example1() -> String {
            var gameState1 = GameState(player: WizardStats(hitPoints: 10,
                                                           mana: 250),
                                       enemy: EnemyStats(hitPoints: 13,
                                                         damage: 8))

            var gameResult1: GameResult?

            for spell in [Spell.poison, .magicMissile] {
                (gameState1, gameResult1) = playTurn(gameState: gameState1,
                                                     casting: spell)
            }

            return "\(gameResult1!)"
        }

        public static func example2() -> String {
            var gameState2 = GameState(player: WizardStats(hitPoints: 10,
                                                           mana: 250),
                                       enemy: EnemyStats(hitPoints: 14,
                                                         damage: 8))

            var gameResult2: GameResult?

            for spell in [Spell.recharge, .shield, .drain, .poison,
                          .magicMissile] {
                (gameState2, gameResult2) = playTurn(gameState: gameState2,
                                                     casting: spell)
            }

            return "\(gameResult2!)"
        }

        private static func leastManaToWin(against enemy: EnemyStats,
                                           isHardMode: Bool = false) -> Int {
            var gameStates = [
                GameState(player: WizardStats(hitPoints: 50, mana: 500),
                          enemy: enemy)
            ]

            var lowestScore: Int = .max

            while !gameStates.isEmpty {
                var nextStates = product(gameStates, Spell.allCases).map {
                    playTurn(gameState: $0,
                             casting: $1,
                             isHardDifficulty: isHardMode)
                }
                .filter { $0.1 != .playerLost }

                for (game, result) in nextStates where result == .playerWon {
                    lowestScore = min(game.spentMana, lowestScore)
                }

                nextStates.removeAll { $0.0.spentMana >= lowestScore }

                gameStates = nextStates.map { $0.0 }
            }

            return lowestScore
        }

        public static func part1() -> String {
            let enemy = EnemyStats(string: puzzleInput())!

            let leastManaToWin = self.leastManaToWin(against: enemy)
            return "\(leastManaToWin)"
        }

        public static func part2() -> String {
            let enemy = EnemyStats(string: puzzleInput())!

            let leastManaToWin = self.leastManaToWin(against: enemy,
                                                     isHardMode: true)

            return "\(leastManaToWin)"
        }

    }

}
