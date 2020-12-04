//
//  Day1.swift
//  AdventOfCode2020
//
//  Created by Jeff Kelley on 12/4/20.
//

import Foundation

fileprivate let exampleInput = 
    """
    1721
    979
    366
    299
    675
    1456
    """


enum Day1 {
    
    private static func countEntries(_ count: Int,
                                     in array: [Int],
                                     summingTo sum: Int) -> [Int]? {
        if count == 1 {
            return array.first { $0 == sum }.map { [$0] }
        }
        else {
            let tail = Array(array.dropFirst())
            
            for entry in array where entry < sum {
                if let entries = countEntries(count - 1,
                                              in: tail,
                                              summingTo: sum - entry) {
                    return entries + [entry]
                }
            }
        }
        
        return nil
    }
    
    static func example1() {
        let input = parseInputLines(exampleInput, using: Int.init)  
        guard let entries = countEntries(2, in: input, summingTo: 2020) else {
            fatalError()
        }
        
        print(entries.reduce(1, *))
    }
    
    static func part1() {
        let part1Input = parseInputLines(inputForDay(1), using: Int.init)
        
        guard let entries = countEntries(2, in: part1Input, summingTo: 2020) else {
            fatalError()
        }
        
        print(entries.reduce(1, *))
    }
    
    static func example2() {
        let input = parseInputLines(exampleInput, using: Int.init)  
        guard let entries = countEntries(3, in: input, summingTo: 2020) else {
            fatalError()
        }
        
        print(entries.reduce(1, *))
    }
    
    static func part2() {
        let part2Input = parseInputLines(inputForDay(1), using: Int.init)
        
        guard let entries = countEntries(3, in: part2Input, summingTo: 2020) else {
            fatalError()
        }
        
        print(entries.reduce(1, *))
    }
    
}
