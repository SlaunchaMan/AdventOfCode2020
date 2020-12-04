//
//  Day2.swift
//  AdventOfCode2020
//
//  Created by Jeff Kelley on 12/4/20.
//

import Foundation

fileprivate let exampleInput =
    """
    1-3 a: abcde
    1-3 b: cdefg
    2-9 c: ccccccccc
    """

extension String {
    
    func count(of character: Character) -> Int {
        filter { $0 == character }.count
    }
    
}

enum Day2 {
    
    struct Requirement: CustomStringConvertible {
        let firstNumber: Int
        let secondNumber: Int
        let letter: Character
        
        var range: ClosedRange<Int> { firstNumber...secondNumber }
        
        func evaluatePart1(_ password: String) -> Bool {
            range.contains(password.count(of: letter))
        }
        
        func evaluatePart2(_ password: String) -> Bool {
            let firstIndex = password.index(password.startIndex,
                                            offsetBy: firstNumber - 1)
            
            let secondIndex = password.index(password.startIndex,
                                             offsetBy: secondNumber - 1)
            
            switch (password[firstIndex], password[secondIndex]) {
            case (letter, letter): return false
            case (letter, _): return true
            case (_, letter): return true
            default: return false
            }
        }
        
        var description: String {
            "\(range.lowerBound)-\(range.upperBound) \(letter)"
        }
    }
    
    static func parseInputLine(_ line: String) -> (Requirement, String)? {
        let scanner = Scanner(string: line)
        
        guard let first = scanner.scanInt() else { return nil }
        let _ = scanner.scanCharacter()
        guard let second = scanner.scanInt() else { return nil }
        let _ = scanner.scanString(" ")
        guard let target = scanner.scanCharacter() else { return nil }
        let _ = scanner.scanString(": ")
        
        guard let string = scanner.scanUpToString("\n") else { return nil }
        
        return (Requirement(firstNumber: first,
                            secondNumber: second,
                            letter: target),
                string)
    }
    
    static func example1() {
        let input = parseInputLines(exampleInput, using: parseInputLine)
        
        for (requirement, password) in input {
            print("\(requirement): \(password): \(requirement.evaluatePart1(password) ? "valid": "invalid")")
        }
        
        print(input.filter { $0.0.evaluatePart1($0.1) }.count)
    }
    
    static func part1() {
        let input = parseInputLines(inputForDay(2), using: parseInputLine)
        print(input.filter { $0.0.evaluatePart1($0.1) }.count)
    }
    
    static func example2() {
        let input = parseInputLines(exampleInput, using: parseInputLine)
        
        for (requirement, password) in input {
            print("\(requirement): \(password): \(requirement.evaluatePart2(password) ? "valid": "invalid")")
        }
        
        print(input.filter { $0.0.evaluatePart2($0.1) }.count)
    }
    
    static func part2() {
        let input = parseInputLines(inputForDay(2), using: parseInputLine)
        print(input.filter { $0.0.evaluatePart2($0.1) }.count)
    }
    
}
