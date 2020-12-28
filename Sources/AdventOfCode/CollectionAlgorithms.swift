//
//  CollectionAlgorithms.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Algorithms
import Foundation

extension Sequence where Element: Equatable {

    func firstElementRepeating(times: Int = 2) -> Element? {
        var iterator = makeIterator()

        var queue: [Element] = []

        for _ in 0 ..< times - 1 {
            guard let next = iterator.next() else { return nil }
            queue.append(next)
        }

        while let next = iterator.next() {
            queue.append(next)
            if queue.allSatisfy({ $0 == queue[0] }) { return queue[0] }
            queue.removeFirst()
        }

        return nil
    }

}

extension StringProtocol {

    func allRanges<T: StringProtocol>(
        of aString: T,
        options: String.CompareOptions = [],
        locale: Locale? = nil
    ) -> [Range<Index>] {
        var ranges: [Range<Index>] = []

        var searchRange = startIndex ..< endIndex

        while let nextRange = range(
                of: aString,
                options: options,
                range: searchRange,
                locale: locale
        ) {
            ranges.append(nextRange)

            let nextLowerBound = index(after: searchRange.lowerBound)

            guard nextLowerBound < endIndex else { break }

            searchRange = nextLowerBound ..< endIndex
        }

        return ranges
    }

}

extension Sequence {

    func allMap<T>(
        into result: inout [T],
        _ transform: (Element) throws -> T?
    ) rethrows -> Bool {
        let results = try map(transform)

        if results.allSatisfy({
            switch $0 {
            case .none: return false
            case .some: return true
            }
        }) {
            result = results.compactMap { $0 }
            return true
        }
        else {
            return false
        }
    }

}

extension Sequence where Element: Equatable {

    var abaPatterns: [[Element]] {
        var result: [[Element]] = []
        var iterator = makeIterator()

        guard var a1 = iterator.next(),
              var b = iterator.next()
        else { return [] }

        while let a2 = iterator.next() {
            if a1 == a2 && a1 != b {
                result.append([a1, b, a2])
            }

            a1 = b
            b = a2
        }

        return result
    }

    var hasABBAPattern: Bool {
        var iterator = makeIterator()

        guard var a1 = iterator.next(),
              var b1 = iterator.next(),
              var b2 = iterator.next()
        else { return false }

        while let a2 = iterator.next() {
            if a1 == a2 && b1 == b2 && a1 != b1 {
                return true
            }

            a1 = b1
            b1 = b2
            b2 = a2
        }

        return false
    }

}

extension Collection {

    func wrappingIndex(after index: Index) -> Index {
        let next = self.index(after: index)

        return (next == endIndex ? startIndex : next)
    }

}

extension RangeReplaceableCollection {

    mutating func removeAndReturn(
        where predicate: (Element) throws -> Bool
    ) rethrows -> [Element] {
        var indexesToRemove: [Index] = []

        for (index, element) in self.indexed() where try predicate(element) {
            indexesToRemove.append(index)
        }

        var result: [Element] = []

        for index in indexesToRemove.reversed() {
            result.insert(remove(at: index), at: result.startIndex)
        }

        return result
    }

}

extension Collection where Index == Int {

    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

}

extension Collection where Element: Collection {

    typealias Position = (outerIndex: Index, innerIndex: Element.Index)

}

extension Collection where Self == SubSequence {

    mutating func removeAndReturnFirst(_ n: Int) -> [Element] {
        (0 ..< n).reduce(into: []) { result, _ in result.append(removeFirst()) }
    }

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

    func first(
        where predicate: (Element.Element) throws -> Bool
    ) rethrows -> Element.Element? {
        guard let position = try firstPosition(where: predicate)
        else { return nil }

        return self[position.outerIndex][position.innerIndex]
    }

    func firstPosition(
        where predicate: (Element.Element) throws -> Bool
    ) rethrows -> Position? {
        var outerIndex = startIndex

        while outerIndex != endIndex {
            let inner = self[outerIndex]

            if let innerIndex = try inner.firstIndex(where: predicate) {
                return (outerIndex, innerIndex)
            }

            outerIndex = index(after: outerIndex)
        }

        return nil
    }

    func directNeighbors(of position: Position,
                         wrapping: Bool = false,
                         includesStart: Bool = false) -> [Position] {
        let outerNeighbors = neighboringIndexes(of: position.outerIndex,
                                                wrapping: wrapping)
            .map { (outerIndex: $0, innerIndex: position.innerIndex) }

        let innerNeighbors = self[position.outerIndex].neighboringIndexes(
            of: position.innerIndex,
            wrapping: wrapping
        ).map { (outerIndex: position.outerIndex, innerIndex: $0) }

        var neighbors: [Position] = []

        if includesStart {
            neighbors.append(position)
        }

        neighbors.append(contentsOf: outerNeighbors)
        neighbors.append(contentsOf: innerNeighbors)

        return neighbors
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

extension BidirectionalCollection
where Element: BidirectionalCollection, Element.Element: Equatable {

    func firstPosition(of element: Element.Element) -> Position? {
        firstPosition { $0 == element }
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
