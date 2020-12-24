//
//  ContainsAny.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/23/20.
//

import Foundation

extension Sequence where Element: Equatable {

    func containsAny<T: Sequence>(
        in otherSequence: T
    ) -> Bool where T.Element == Element {
        for element in otherSequence {
            if self.contains(element) {
                return true
            }
        }

        return false
    }

}

extension StringProtocol {

    func containsAny<T: StringProtocol>(in strings: [T]) -> Bool {
        for string in strings {
            if self.contains(string) {
                return true
            }
        }

        return false
    }

}
