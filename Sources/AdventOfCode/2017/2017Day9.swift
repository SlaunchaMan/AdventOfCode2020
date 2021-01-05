//
//  2017Day9.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 01/4/21.
//

import Foundation

private let exampleInput1 =
    """
    {}
    {{{}}}
    {{},{}}
    {{{},{},{{}}}}
    {<a>,<a>,<a>,<a>}
    {{<ab>},{<ab>},{<ab>},{<ab>}}
    {{<!!>},{<!!>},{<!!>},{<!!>}}
    {{<a!>},{<a!>},{<a!>},{<ab>}}
    """

private let exampleInput2 =
    """
    <>
    <random characters>
    <<<<>
    <{!>}>
    <!!>
    <!!!>>
    <{o"i!a,<{i<a>
    """

extension Year2017 {

    public enum Day9: FullPuzzle {

        public static let year: Year.Type = Year2017.self

        public static let day = 9
        
        struct Group {
            
            struct Garbage {
                let contents: String
                
                init(string: String) {
                    var iterator = string.makeIterator()

                    precondition(iterator.next() == "<",
                                 "Garbage must start with <")
                    
                    self.init(iterator: &iterator)
                }
                
                init(iterator: inout String.Iterator) {
                    var contents = ""
                    
                    while let next = iterator.next() {
                        switch next {
                        case "!":
                            _ = iterator.next()
                        case ">":
                            self.contents = contents
                            return
                        default:
                            contents.append(next)
                        }
                    }
                    
                    preconditionFailure(
                        "Never finished group with non-cancelled >"
                    )
                }
            }
            
            let children: [Either<Group, Garbage>]
            
            init(string: String) {
                var iterator = string.makeIterator()

                precondition(iterator.next() == "{",
                             "Groups must start with {")
                
                self.init(iterator: &iterator)
            }
            
            private init(iterator: inout String.Iterator) {
                var children: [Either<Group, Garbage>] = []
                
                while let next = iterator.next() {
                    switch next {
                    case ",": break
                    case "<":
                        let garbage = Garbage(iterator: &iterator)
                        children.append(.second(garbage))
                    case "{":
                        let group = Group(iterator: &iterator)
                        children.append(.first(group))
                    case "}":
                        self.children = children
                        return
                    default:
                        preconditionFailure("Unexpected character: \(next)")
                    }
                }
                
                preconditionFailure("Groups must end with }")
            }
            
            func score(braceLevel: Int = 0) -> Int {
                braceLevel + 1 + children
                    .compactMap(\.first)
                    .map { $0.score(braceLevel: braceLevel + 1) }
                    .sum()
            }
            
            var garbageCount: Int {
                children.reduce(0) {
                    if case let .second(garbage) = $1 {
                        return $0 + garbage.contents.count
                    }
                    else if case let .first(group) = $1 {
                        return $0 + group.garbageCount
                    }
                    else {
                        return $0
                    }
                }
            }
            
        }
        
        public static func example1() -> String {
            let exampleGroups = parseInputLines(exampleInput1,
                                                using: Group.init)
            
            return exampleGroups.map { $0.score() }.map(String.init)
                .joined(separator: ",")
        }

        public static func part1() -> String {
            String(Group(string: puzzleInput()).score())
        }

        public static func example2() -> String {
            let exampleGarbage = parseInputLines(exampleInput2,
                                                 using: Group.Garbage.init)
            
            return exampleGarbage.map(\.contents).map(\.count).map(String.init)
                .joined(separator: ",")
        }

        public static func part2() -> String {
            String(Group(string: puzzleInput()).garbageCount)
        }

    }

}
