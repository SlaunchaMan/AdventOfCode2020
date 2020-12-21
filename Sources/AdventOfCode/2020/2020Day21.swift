//
//  2020Day21.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/21/20.
//

import Foundation

private let exampleInput =
    """
    mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
    trh fvjkl sbzzf mxmxvkd (contains dairy)
    sqjhc fvjkl (contains soy)
    sqjhc mxmxvkd sbzzf (contains fish)
    """

extension Year2020 {

    public enum Day21: FullPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 21

        struct FoodItem {
            let ingredients: Set<String>
            let allergens: Set<String>

            init?(string: String) {
                var ingredients: Set<String> = []
                var allergens: Set<String> = []

                let scanner = Scanner(string: string)

                guard let ingredientsList = scanner.scanUpToString("(")
                else { return nil }

                let ingredientsScanner = Scanner(string: ingredientsList)

                while let ingredient = ingredientsScanner.scanUpToCharacters(
                        from: .whitespaces
                ) {
                    ingredients.insert(ingredient)
                }

                if scanner.scanString("(contains") != nil,
                   let allergensList = scanner.scanUpToString(")") {
                    allergensList.components(separatedBy: ", ").forEach {
                        allergens.insert($0)
                    }
                }

                self.ingredients = ingredients
                self.allergens = allergens
            }
        }

        private static func allergens(
            in input: [FoodItem]
        ) -> [String: String] {
            var allAllergens = input.reduce(into: Set<String>()) {
                $0.formUnion($1.allergens)
            }

            var decodedAllergens: [String: String] = [:]

            while !allAllergens.isEmpty {
                for allergen in allAllergens {
                    var food = input.filter { $0.allergens.contains(allergen) }
                        .map { $0.ingredients }
                        .map {
                            $0.filter {
                                !decodedAllergens.keys.contains($0)
                            }
                        }

                    let first = food.removeFirst()

                    let uniqueIngredients = food.reduce(into: first) {
                        $0.formIntersection($1)
                    }

                    if uniqueIngredients.count == 1 {
                        decodedAllergens[uniqueIngredients.first!] = allergen
                        allAllergens.remove(allergen)
                    }
                }
            }

            return decodedAllergens
        }

        private static func nonAllergenIngredientCount(
            in foodItems: [FoodItem]
        ) -> Int {
            let map = allergens(in: foodItems)

            return foodItems.reduce(0) {
                $0 + $1.ingredients.filter { !map.keys.contains($0) }.count
            }
        }

        public static func example1() -> String {
            let foodItems = parseInputLines(exampleInput, using: FoodItem.init)
            return "\(nonAllergenIngredientCount(in: foodItems))"
        }

        public static func part1() -> String {
            let foodItems = parseInputLines(puzzleInput(), using: FoodItem.init)
            return "\(nonAllergenIngredientCount(in: foodItems))"
        }

        private static func canonicalDangerousIngredientsList(
            in foodItems: [FoodItem]
        ) -> String {
            allergens(in: foodItems)
                .sorted { $0.value < $1.value }
                .map { $0.key }
                .joined(separator: ",")
        }

        public static func example2() -> String {
            let foodItems = parseInputLines(exampleInput, using: FoodItem.init)
            return canonicalDangerousIngredientsList(in: foodItems)
        }

        public static func part2() -> String {
            let foodItems = parseInputLines(puzzleInput(), using: FoodItem.init)
            return canonicalDangerousIngredientsList(in: foodItems)
        }

    }

}
