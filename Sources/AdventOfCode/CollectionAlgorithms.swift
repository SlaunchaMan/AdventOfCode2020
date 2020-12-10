//
//  CollectionAlgorithms.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Algorithms
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

extension Collection where Element: Collection {

    typealias Position = (outerIndex: Index, innerIndex: Element.Index)

}

extension BidirectionalCollection {

    var lastIndex: Index {
        index(before: endIndex)
    }

    func neighboringIndexes(of index: Index,
                            wrapping: Bool = false,
                            includesStart: Bool = true) -> [Index] {
        var indexes: [Index] = []

        if index == startIndex {
            if wrapping {
                indexes.append(lastIndex)
            }
        }
        else {
            indexes.append(self.index(before: index))
        }

        if includesStart {
            indexes.append(index)
        }

        if self.index(after: index) == endIndex {
            if wrapping {
                indexes.append(startIndex)
            }
        }
        else {
            indexes.append(self.index(after: index))
        }

        return indexes
    }

}

extension BidirectionalCollection where Element: BidirectionalCollection {

    var cornerIndexes: [Position] {
        [
            (startIndex, self[startIndex].startIndex),
            (startIndex, self[startIndex].lastIndex),
            (lastIndex, self[lastIndex].startIndex),
            (lastIndex, self[lastIndex].lastIndex)
        ]
    }

    func neighbors(of position: Position,
                   wrapping: Bool = false,
                   includesStart: Bool = false) -> [Position] {
        product(
            neighboringIndexes(of: position.outerIndex, wrapping: wrapping),
            self[position.outerIndex].neighboringIndexes(
                of: position.innerIndex,
                wrapping: wrapping
            )
        )
        .filter { outerIndex, innerIndex in
            includesStart || !(outerIndex == position.outerIndex &&
                                innerIndex == position.innerIndex)
        }
    }

}

extension MutableCollection where Element: MutableCollection {

    subscript(_ position: Position) -> Element.Element {
        get { self[position.outerIndex][position.innerIndex] }
        set { self[position.outerIndex][position.innerIndex] = newValue }
    }

}

extension RangeReplaceableCollection where Element: RangeReplaceableCollection {

    subscript(_ position: Position) -> Element.Element {
        get { self[position.outerIndex][position.innerIndex] }
        set {
            var element = self[position.outerIndex]
            let innerRange = position.innerIndex ..< element.index(
                after: position.innerIndex
            )

            element.replaceSubrange(innerRange, with: [newValue])

            let outerRange = position.outerIndex ..< index(
                after: position.outerIndex
            )

            replaceSubrange(outerRange, with: [element])
        }
    }

}
