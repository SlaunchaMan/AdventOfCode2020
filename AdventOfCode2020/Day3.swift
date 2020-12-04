//
//  Day3.swift
//  AdventOfCode2020
//
//  Created by Jeff Kelley on 12/4/20.
//

import Foundation

fileprivate let exampleInput =
    """
    ..##.......
    #...#...#..
    .#....#..#.
    ..#.#...#.#
    .#...##..#.
    ..#.##.....
    .#.#.#....#
    .#........#
    #.##...#...
    #...##....#
    .#..#...#.#
    """

enum Day3 {
    
    static func treeCollisions(
        using input: [String],
        slope: (Int, Int) = (3, 1)
    ) -> Int {
        let width = input[0].count
        var collisions = 0
        
        for (row, line) in input.enumerated()
        where (row % slope.1) == 0 && !line.isEmpty {
            let col = ((row * slope.0) / slope.1) % width
            
            if line[line.index(line.startIndex, offsetBy: col)] == "#" {
                collisions += 1
            }
        }
        
        return collisions
    }
    
    static func example1() {
        print(treeCollisions(using: parseInputLines(exampleInput)))
    }
    
    static func part1() {
        print(treeCollisions(using: parseInputLines(inputForDay(3))))
    }
    
    static func example2() {
        let collisions =
            [treeCollisions(using: parseInputLines(exampleInput), slope: (1,1)),
             treeCollisions(using: parseInputLines(exampleInput), slope: (3,1)),
             treeCollisions(using: parseInputLines(exampleInput), slope: (5,1)),
             treeCollisions(using: parseInputLines(exampleInput), slope: (7,1)),
             treeCollisions(using: parseInputLines(exampleInput), slope: (1,2))]
        
        print("\(collisions.map(String.init).joined(separator: ", ")): \(collisions.reduce(1, *))")
    }
    
    static func part2() {
        let input = inputForDay(3)
        let collisions =
            [treeCollisions(using: parseInputLines(input), slope: (1,1)),
             treeCollisions(using: parseInputLines(input), slope: (3,1)),
             treeCollisions(using: parseInputLines(input), slope: (5,1)),
             treeCollisions(using: parseInputLines(input), slope: (7,1)),
             treeCollisions(using: parseInputLines(input), slope: (1,2))]
        
        print(collisions.reduce(1, *))
    }
    
}
