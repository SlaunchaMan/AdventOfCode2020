//
//  Numerics.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/11/20.
//

import Foundation

extension Int {

    public func factors(startingAt start: Int = 1) -> [Int] {
        var factors: [Int] = []

        for factor in start...self where isMultiple(of: factor) {
            factors.append(factor)
        }

        return factors
    }

}
