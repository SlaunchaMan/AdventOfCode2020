//
//  2020Day23.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/23/20.
//

import Foundation

extension Year2020 {

    public enum Day23: PuzzleWithExample1 {

        public static let year: Year.Type = Year2020.self

        public static let day = 23

        private static func cups(from input: String) -> [Int] {
            input.map { String($0) }.compactMap(Int.init)
        }

        private static func cupsDescription(_ list: CircularList<Int>,
                                            currentCup: Int) -> String {
            var result = ""

            var iterator = list.makeIterator()

            while let cup = iterator.next() {
                if cup == currentCup {
                    result.append("(\(cup))")
                }
                else {
                    result.append(" \(cup) ")
                }
            }

            return result
        }

        private static func finalOneNode(
            cups: [Int],
            moves: Int
        ) -> CircularList<Int>.Node? {
            guard let min = cups.min(),
                  let max = cups.max()
            else { preconditionFailure() }

            var list = CircularList(cups)
            let searchDict = list.generateSearchDict()

            for move in 1 ... moves {
                log("-- move \(move) --")
                log("cups: " +
                        cupsDescription(list,
                                        currentCup: list.currentNode!.value))

                var destinationLabel = list.currentNode!.value

                let firstPickedUpCup = list.currentNode!.next!
                let secondPickedUpCup = firstPickedUpCup.next!
                let thirdPickedUpCup = secondPickedUpCup.next!

                let pickedUpCups = [firstPickedUpCup,
                                    secondPickedUpCup,
                                    thirdPickedUpCup].map(\.value)

                log("pick up: " +
                        pickedUpCups
                        .map(String.init)
                        .joined(separator: ", "))

                list.currentNode!.next = thirdPickedUpCup.next!

                repeat {
                    destinationLabel -= 1
                    if destinationLabel < min {
                        destinationLabel = max
                    }
                } while ([list.currentNode!.value] + pickedUpCups)
                    .contains(destinationLabel)
                    || !searchDict.keys.contains(destinationLabel)

                log("destination: \(destinationLabel)")
                let destinationNode = searchDict[destinationLabel]!

                let currentNext = destinationNode.next
                destinationNode.next = firstPickedUpCup
                thirdPickedUpCup.next = currentNext

                list.currentNode = list.currentNode?.next
                log("")
            }

            log("-- final --")
            log("cups: " +
                    cupsDescription(list, currentCup: list.currentNode!.value))

            return searchDict[1]
        }

        private static func runGamePart1(cups: [Int], moves: Int) -> String {
            guard let oneNode = finalOneNode(cups: cups, moves: moves)
            else { preconditionFailure() }

            var result = ""

            var nextNode = oneNode.next

            while let node = nextNode, node.value != 1 {
                result.append(String(node.value))
                nextNode = node.next
            }

            return result
        }

        public static func example1() -> String {
            "\(runGamePart1(cups: cups(from: "389125467"), moves: 10))"
        }

        public static func part1() -> String {
            "\(runGamePart1(cups: cups(from: puzzleInput()), moves: 100))"
        }

        private static func runGamePart2(cups: [Int], moves: Int) -> String {
            guard let oneNode = finalOneNode(cups: cups, moves: moves)
            else { preconditionFailure() }

            return "\(oneNode.next!.value * oneNode.next!.next!.value)"
        }

        public static func part2() -> String {
            var cups = self.cups(from: puzzleInput())

            guard let max = cups.max() else { preconditionFailure() }

            cups.append(contentsOf: (max + 1) ... 1_000_000)

            return "\(runGamePart2(cups: cups, moves: 10_000_000))"
        }

    }

}
