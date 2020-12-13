//
//  Numerics.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/11/20.
//

import Foundation

extension Int {

    public func factors(startingAt start: Int = 1) -> [Int] {
        var factors: Set<Int> = []
        let stop = Int(sqrt(Double(self))) + 1

        for factor in 1...stop where isMultiple(of: factor) {
            factors.insert(factor)
            factors.insert(self / factor)
        }

        if start > 1 {
            factors = factors.filter { $0 >= start }
        }

        return factors.sorted()
    }

}
