//
//  2015Day15.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/7/20.
//

import Foundation
import IsNotEmpty
import StringDecoder

private let exampleInput =
    """
    Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
    Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
    """

extension Year2015 {

    public enum Day15: Puzzle {

        public static let year: Year.Type = Year2015.self

        public static let day = 15

        struct Ingredient: Decodable, Equatable, Hashable {
            let name: String
            let capacity: Int
            let durability: Int
            let flavor: Int
            let texture: Int
            let calories: Int
        }

        private static func permutations(
            of ingredients: [Ingredient],
            totalling total: Int
        ) -> [[Ingredient: Int]] {
            precondition(ingredients.isNotEmpty)

            if ingredients.count == 1 {
                return [[ingredients[0]: total]]
            }
            else {
                let ingredient = ingredients[0]
                let leftovers = Array(ingredients[1...])

                var permutations: [[Ingredient: Int]] = []

                for i in 1 ..< total {
                    let nextPermutations = self.permutations(
                        of: leftovers,
                        totalling: total - i
                    )

                    permutations.append(contentsOf: nextPermutations.map {
                        var permutation = $0
                        permutation[ingredient] = i
                        return permutation
                    })
                }

                return permutations
            }
        }

        private static func score(ofRecipe recipe: [Ingredient: Int]) -> Int {
            let scoreKeyPaths = [\Ingredient.capacity,
                                 \.durability,
                                 \.flavor,
                                 \.texture]

            let ingredients = recipe.keys

            let scores = scoreKeyPaths.map { keyPath in
                ingredients.compactMap { ingredient in
                    if let amount = recipe[ingredient] {
                        return amount * ingredient[keyPath: keyPath]
                    }

                    return nil
                }
                .reduce(0, +)
            }

            if scores.contains(where: { $0 < 0 }) { return 0 }

            return scores.productOfElements()
        }

        // swiftlint:disable:next line_length
        private static let ingredientFormatString = "$(name): capacity $(capacity), durability $(durability), flavor $(flavor), texture $(texture), calories $(calories)"

        public static func example1() -> String {
            let decoder = StringDecoder(formatString: ingredientFormatString)

            let ingredients = parseInputLines(exampleInput) {
                try? decoder.decode(Ingredient.self, from: $0)
            }

            let permutations = self.permutations(of: ingredients,
                                                 totalling: 100)

            let scores = permutations.map { score(ofRecipe: $0) }

            return "\(scores.max()!)"
        }

        public static func part1() -> String {
            let decoder = StringDecoder(formatString: ingredientFormatString)

            let ingredients = parseInputLines(puzzleInput()) {
                try? decoder.decode(Ingredient.self, from: $0)
            }

            let permutations = self.permutations(of: ingredients,
                                                 totalling: 100)

            let scores = permutations.map { score(ofRecipe: $0) }

            return "\(scores.max()!)"
        }

        public static func example2() -> String {
            let decoder = StringDecoder(formatString: ingredientFormatString)

            let ingredients = parseInputLines(exampleInput) {
                try? decoder.decode(Ingredient.self, from: $0)
            }

            let permutations = self.permutations(of: ingredients,
                                                 totalling: 100)
                .filter {
                    $0.reduce(into: 0) {
                        $0 += $1.key.calories * $1.value
                    } == 500
                }

            let scores = permutations.map { score(ofRecipe: $0) }

            return "\(scores.max()!)"
        }

        public static func part2() -> String {
            let decoder = StringDecoder(formatString: ingredientFormatString)

            let ingredients = parseInputLines(puzzleInput()) {
                try? decoder.decode(Ingredient.self, from: $0)
            }

            let permutations = self.permutations(of: ingredients,
                                                 totalling: 100)
                .filter {
                    $0.reduce(into: 0) {
                        $0 += $1.key.calories * $1.value
                    } == 500
                }

            let scores = permutations.map { score(ofRecipe: $0) }

            return "\(scores.max()!)"
        }

    }

}
