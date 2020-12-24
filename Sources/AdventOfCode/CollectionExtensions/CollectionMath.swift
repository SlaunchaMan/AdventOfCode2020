//
//  CollectionMath.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/23/20.
//

import Foundation

extension Sequence {

    func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        try filter(predicate).count
    }

    func sum<T>(
        _ transform: (Element) throws -> T
    ) rethrows -> T where T: AdditiveArithmetic {
        try map(transform).sum()
    }

}

extension Sequence where Element: AdditiveArithmetic {

    func sum() -> Element {
        reduce(.zero, +)
    }

}

extension Sequence where Element: Equatable {

    func count(of element: Element) -> Int {
        count(where: { $0 == element })
    }

}

extension Sequence where Element: Hashable {

    func histogram() -> [Element: Int] {
        reduce(into: [:]) { $0[$1, default: 0] += 1 }
    }

    func leastCommonElement() -> Element? {
        histogram().min { $0.1 < $1.1 }.map { $0.0 }
    }

    func mostCommonElement() -> Element? {
        histogram().max { $0.1 < $1.1 }.map { $0.0 }
    }

}

extension Sequence where Element: Numeric {

    func productOfElements() -> Element {
        var iterator = makeIterator()

        guard var product = iterator.next() else { return 0 }

        while let next = iterator.next() {
            product *= next
        }

        return product
    }

}
