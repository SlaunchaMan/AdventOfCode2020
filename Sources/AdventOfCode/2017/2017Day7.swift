//
//  2017Day7.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/28/20.
//

import Foundation

private let exampleInput =
    """
    pbga (66)
    xhth (57)
    ebii (61)
    havc (66)
    ktlj (57)
    fwft (72) -> ktlj, cntj, xhth
    qoyq (66)
    padx (45) -> pbga, havc, qoyq
    tknk (41) -> ugml, padx, fwft
    jptl (61)
    ugml (68) -> gyxo, ebii, jptl
    gyxo (61)
    cntj (57)
    """

extension Year2017 {

    public enum Day7: FullPuzzle {

        public static let year: Year.Type = Year2017.self

        public static let day = 7

        class Node: CustomStringConvertible {
            let name: String
            let weight: Int
            var children: [Node] = []
            weak var parent: Node?

            init(name: String, weight: Int) {
                self.name = name
                self.weight = weight
            }

            var childrenDescription: String {
                children.isEmpty ? "" :
                    " -> \(children.map(\.name).joined(separator: ", "))"
            }

            var description: String {
                "\(name) (\(weight))" + childrenDescription
            }

            var isBalanced: Bool {
                children.map(\.totalWeight).areAllEqual()
            }

            var isUnbalanced: Bool { !isBalanced }

            var totalWeight: Int {
                weight + children.sum(\.totalWeight)
            }
        }

        private static func parseNodes(input: String) -> [Node] {
            var nodes: [Node] = []

            func node(withName name: String) -> Node? {
                nodes.first { $0.name == name }
            }

            for line in input.components(separatedBy: .newlines)
            where line.components(separatedBy: .whitespaces).count > 1 {
                var components = line.components(separatedBy: .whitespaces)

                let name = components.removeFirst()

                guard let weight = Int(
                    components.removeFirst()
                        .trimmingCharacters(
                            in: CharacterSet.decimalDigits.inverted
                        )
                ) else { continue }

                nodes.append(Node(name: name, weight: weight))
            }

            for line in input.components(separatedBy: .newlines)
            where line.components(separatedBy: " -> ").count == 2 {
                let parentName = line.components(separatedBy: .whitespaces)[0]

                guard let parent = node(withName: parentName) else {
                    continue
                }

                let children = line
                    .components(separatedBy: " -> ")[1]
                    .components(separatedBy: ", ")

                for child in children.compactMap(node(withName:)) {
                    child.parent = parent
                    parent.children.append(child)
                }
            }

            return nodes
        }

        private static func root(of nodes: [Node]) -> Node? {
            nodes.first { $0.parent == nil }
        }

        public static func example1() -> String {
            root(of: parseNodes(input: exampleInput))!.name
        }

        public static func part1() -> String {
            root(of: parseNodes(input: puzzleInput()))!.name
        }

        private static func weightToBalance(nodes: [Node]) -> (String, Int) {
            guard let root = root(of: nodes),
                  let targetWeight = root.children.map(\.totalWeight)
                    .mostCommonElement(),
                  var unbalanced = root.children.first(
                    where: { $0.totalWeight != targetWeight }
                  )
            else { preconditionFailure() }

            let diff = targetWeight - unbalanced.totalWeight

            while unbalanced.isUnbalanced {
                guard let targetWeight = unbalanced.children.map(\.totalWeight)
                        .mostCommonElement()
                else { preconditionFailure() }

                unbalanced = unbalanced.children.first(
                    where: { $0.totalWeight != targetWeight }
                )!
            }

            return (unbalanced.name, unbalanced.weight + diff)
        }

        public static func example2() -> String {
            "\(weightToBalance(nodes: parseNodes(input: exampleInput)).1)"
        }

        public static func part2() -> String {
            "\(weightToBalance(nodes: parseNodes(input: puzzleInput())).1)"
        }

    }

}
