//
//  2020Day22.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/22/20.
//

import Foundation
import IsNotEmpty

private let exampleInput =
    """
    Player 1:
    9
    2
    6
    3
    1

    Player 2:
    5
    8
    4
    7
    10
    """

extension Year2020 {

    public enum Day22: FullPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 22

        private static func parseDecks(from input: String) -> ([Int], [Int]) {
            let components = input.components(separatedBy: "\n\n")
            precondition(components.count == 2)

            let decks = components.map {
                $0.components(separatedBy: .newlines)
                    .dropFirst()
                    .compactMap(Int.init)
            }

            return (decks[0], decks[1])
        }

        private static func deckDesription(_ deck: [Int]) -> String {
            deck.map(String.init).joined(separator: ", ")
        }

        private static func score(for deck: [Int]) -> Int {
            deck
                .reversed()
                .enumerated()
                .reduce(0) { score, element in
                    let (index, card) = element
                    return score + (card * (index + 1))
                }
        }

        private static func playGame(_ player1Deck: inout [Int],
                                     _ player2Deck: inout [Int]) -> Int {
            var round = 1

            while player1Deck.isNotEmpty && player2Deck.isNotEmpty {
                log("-- Round \(round) --")
                log("Player 1's deck: \(deckDesription(player1Deck))")
                log("Player 2's deck: \(deckDesription(player2Deck))")

                let player1Card = player1Deck.removeFirst()
                let player2Card = player2Deck.removeFirst()

                log("Player 1 plays: \(player1Card)")
                log("Player 2 plays: \(player2Card)")

                if player1Card > player2Card {
                    log("Player 1 wins the round!")
                    player1Deck.append(player1Card)
                    player1Deck.append(player2Card)
                }
                else if player2Card > player1Card {
                    log("Player 2 wins the round!")
                    player2Deck.append(player2Card)
                    player2Deck.append(player1Card)
                }

                log("")

                round += 1
            }

            log("")
            log("== Post-game results ==")
            log("Player 1's deck: \(deckDesription(player1Deck))")
            log("Player 2's deck: \(deckDesription(player2Deck))")

            return score(
                for: [player1Deck, player2Deck].filter(\.isNotEmpty)[0]
            )
        }

        public static func example1() -> String {
            var (player1Deck, player2Deck) = parseDecks(from: exampleInput)

            return "\(playGame(&player1Deck, &player2Deck))"
        }

        public static func part1() -> String {
            var (player1Deck, player2Deck) = parseDecks(from: puzzleInput())

            return "\(playGame(&player1Deck, &player2Deck))"
        }

        // swiftlint:disable:next function_body_length
        private static func playRecursive(
            _ player1Deck: [Int],
            _ player2Deck: [Int],
            game: inout Int
        ) -> (player1Wins: Bool, winningScore: Int) {
            let thisGame = game
            log("=== Game \(thisGame) ===\n")

            var history: Set<[[Int]]> = []
            var round = 1
            var player1Deck = player1Deck
            var player2Deck = player2Deck

            while player1Deck.isNotEmpty && player2Deck.isNotEmpty {
                if history.contains([player1Deck, player2Deck]) {
                    log("Player 1 wins round \(round) of game \(thisGame)!")
                    return (true, score(for: player1Deck))
                }

                history.insert([player1Deck, player2Deck])

                log("-- Round \(round) (Game \(game)) --")
                log("Player 1's deck: \(deckDesription(player1Deck))")
                log("Player 2's deck: \(deckDesription(player2Deck))")

                let player1Card = player1Deck.removeFirst()
                let player2Card = player2Deck.removeFirst()

                log("Player 1 plays: \(player1Card)")
                log("Player 2 plays: \(player2Card)")

                if player1Card <= player1Deck.count,
                   player2Card <= player2Deck.count {
                    log("Playing a sub-game to determine the winner...")

                    game += 1
                    let (player1Wins, _) = playRecursive(
                        Array(player1Deck.prefix(player1Card)),
                        Array(player2Deck.prefix(player2Card)),
                        game: &game
                    )

                    if player1Wins {
                        log("Player 1 wins round \(round) of game \(game)!")
                        player1Deck.append(player1Card)
                        player1Deck.append(player2Card)
                    }
                    else {
                        log("Player 2 wins round \(round) of game \(game)!")
                        player2Deck.append(player2Card)
                        player2Deck.append(player1Card)
                    }

                    log("\n...anyway, back to game \(thisGame).")
                }
                else if player1Card > player2Card {
                    log("Player 1 wins round \(round) of game \(thisGame)!")
                    player1Deck.append(player1Card)
                    player1Deck.append(player2Card)
                }
                else if player2Card > player1Card {
                    log("Player 2 wins round \(round) of game \(thisGame)!")
                    player2Deck.append(player2Card)
                    player2Deck.append(player1Card)
                }

                log("")

                round += 1
            }

            log("")
            log("== Post-game results ==")
            log("Player 1's deck: \(deckDesription(player1Deck))")
            log("Player 2's deck: \(deckDesription(player2Deck))")

            return (player1Deck.isNotEmpty, score(
                for: [player1Deck, player2Deck] .filter(\.isNotEmpty)[0]
            ))
        }

        public static func example2() -> String {
            let (player1Deck, player2Deck) = parseDecks(from: exampleInput)
            var game = 1

            return "\(playRecursive(player1Deck, player2Deck, game: &game).1)"
        }

        public static func part2() -> String {
            let (player1Deck, player2Deck) = parseDecks(from: puzzleInput())
            var game = 1

            return "\(playRecursive(player1Deck, player2Deck, game: &game).1)"
        }

    }

}
