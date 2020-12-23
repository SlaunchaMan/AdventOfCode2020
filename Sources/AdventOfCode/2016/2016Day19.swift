//
//  2016Day19.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/22/20.
//

import Algorithms
import Foundation

extension Year2016 {

    public enum Day19: FullPuzzle {

        public static let year: Year.Type = Year2016.self

        public static let day = 19

        private static func winningElfPart1(numberOfElves elves: Int) -> Int {
            // https://www.youtube.com/watch?v=uCsD3ZGzMgE
            var binaryRepresentation = String(elves, radix: 2)
            binaryRepresentation.append(binaryRepresentation.removeFirst())
            return Int(binaryRepresentation, radix: 2)!
        }

        public static func example1() -> String {
            "\(winningElfPart1(numberOfElves: 5))"
        }

        public static func part1() -> String {
            "\(winningElfPart1(numberOfElves: Int(puzzleInput())!))"
        }

        private static func winningElfPart2(numberOfElves elves: Int) -> Int {
            var elfCount = elves
            var elves = CircularList(1 ... elves)

            var elf = elves.currentNode!
            var targetElf = elves[elfCount / 2]!

            while elfCount > 1 {
                log("Elf \(elf.value) steals from elf \(targetElf.value)")

                if let nextTarget = (elfCount.isMultiple(of: 2) ?
                                        targetElf.next :
                                        targetElf.next?.next) {
                    elves.remove(node: targetElf)
                    elfCount -= 1
                    targetElf = nextTarget
                }

                if let nextElf = elf.next {
                    elf = nextElf
                }
            }

            return elf.value
        }

        public static func example2() -> String {
            return "\(winningElfPart2(numberOfElves: 5))"
        }

        public static func part2() -> String {
            "\(winningElfPart2(numberOfElves: Int(puzzleInput())!))"
        }

    }

}
