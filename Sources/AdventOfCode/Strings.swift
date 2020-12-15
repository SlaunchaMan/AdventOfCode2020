//
//  Strings.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/14/20.
//

import Algorithms
import Foundation

extension String {

    static let uppercaseAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static let lowercaseAlphabet = uppercaseAlphabet.lowercased()

}

extension Character {

    func rotate(_ offset: Int) -> Character? {
        for alphabet in [String.uppercaseAlphabet, .lowercaseAlphabet] {
            let alphabet = alphabet.map { $0 }

            if let index = alphabet.firstIndex(of: self) {
                let newIndex = (index + offset) % alphabet.count
                return alphabet[newIndex]
            }
        }

        return nil
    }

}
