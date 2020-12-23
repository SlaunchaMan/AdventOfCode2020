//
//  BinaryIntegerSet.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/23/20.
//

import Algorithms
import Foundation

struct BinaryIntegerSet<T> where T: FixedWidthInteger {

    struct Range: Equatable {
        let lowerBound: T
        let upperBound: T

        var count: T {
            let width = upperBound - lowerBound

            if width == .max { return width }

            return width + 1
        }

        func contains(_ element: T) -> Bool {
            lowerBound <= element && upperBound >= element
        }

        func difference(_ other: Range) -> Range? {
            guard !other.isSuperset(of: self), overlaps(other)
            else { return nil }

            if lowerBound < other.lowerBound {
                return Range(lowerBound: lowerBound,
                             upperBound: other.lowerBound - 1)
            }
            else {
                precondition(upperBound > other.upperBound)

                return Range(lowerBound: other.upperBound + 1,
                             upperBound: upperBound)
            }
        }

        func intersection(_ other: Range) -> Range? {
            guard overlaps(other) else { return nil }

            return Range(lowerBound: max(lowerBound, other.lowerBound),
                         upperBound: min(upperBound, other.upperBound))
        }

        func isAdjacent(to range: Range) -> Bool {
            (upperBound != .max && upperBound + 1 == range.lowerBound) ||
                (range.upperBound != .max && range.upperBound + 1 == lowerBound)
        }

        func isSuperset(of range: Range) -> Bool {
            lowerBound <= range.lowerBound && upperBound >= range.upperBound
        }

        func overlaps(_ range: Range) -> Bool {
            contains(range.lowerBound) ||
                contains(range.upperBound) ||
                range.contains(lowerBound) ||
                range.contains(upperBound)
        }

        func union(with range: Range) -> Range {
            Range(lowerBound: min(lowerBound, range.lowerBound),
                  upperBound: max(upperBound, range.upperBound))
        }

    }

    var count: T { storage.sum(\.count) }

    private var storage: [Range]

    init() {
        storage = []
    }

    init(lowerBound: T, upperBound: T) {
        storage = [Range(lowerBound: lowerBound, upperBound: upperBound)]
    }

    init(integersIn range: Swift.Range<T>) {
        storage = [Range(lowerBound: range.lowerBound,
                         upperBound: range.upperBound)]
    }

    init<T: Sequence>(_ sequence: T) where T.Iterator.Element == Element {
        self.init()

        var iterator = sequence.makeIterator()
        while let next = iterator.next() {
            self.insert(next)
        }
    }

    func contains(_ member: T) -> Bool {
        storage.contains { $0.contains(member) }
    }

}

extension BinaryIntegerSet: SetAlgebra {

    typealias Element = Range

    // MARK: - Testing for Membership

    func contains(_ member: Element) -> Bool {
        storage.contains { $0.isSuperset(of: member) }
    }

    // MARK: - Adding and Removing Elements

    @discardableResult mutating func insert(
        _ member: Element
    ) -> (inserted: Bool, memberAfterInsert: Element) {
        for (index, range) in storage.indexed() {
            if range.isSuperset(of: member) {
                return (false, range)
            }
            else if range.overlaps(member) || range.isAdjacent(to: member) {
                var newRange = range.union(with: member)

                let nextIndex = storage.index(after: index)
                while nextIndex < storage.endIndex {
                    let nextRange = storage[nextIndex]
                    if newRange.overlaps(nextRange) ||
                        newRange.isAdjacent(to: nextRange) {
                        newRange = newRange.union(with: nextRange)
                        storage.remove(at: index)
                    }
                    else {
                        break
                    }
                }

                storage[index] = newRange

                return (true, newRange)
            }
            else if range.lowerBound > member.upperBound {
                storage.insert(member, at: index)
                return (true, member)
            }
        }

        storage.append(member)
        return (true, member)
    }

    @discardableResult mutating func update(
        with newMember: Element
    ) -> Element? {
        insert(newMember).1
    }

    @discardableResult mutating func remove(_ member: Element) -> Element? {
        if let index = storage.firstIndex(of: member) {
            storage.remove(at: index)
            return member
        }
        else {
            var indexesToRemove: [Int] = []

            defer {
                for index in indexesToRemove {
                    storage.remove(at: index)
                }
            }

            for (index, range) in storage.indexed() {
                if range.isSuperset(of: member) {
                    var replacementRanges: [Range] = []

                    if range.lowerBound < member.lowerBound {
                        replacementRanges.append(
                            Range(lowerBound: range.lowerBound,
                                  upperBound: member.lowerBound - 1)
                        )
                    }

                    if range.upperBound > member.upperBound {
                        replacementRanges.append(
                            Range(lowerBound: member.upperBound + 1,
                                  upperBound: range.upperBound)
                        )
                    }

                    storage.remove(at: index)
                    storage.insert(contentsOf: replacementRanges, at: index)

                    return member
                }
                else if range.overlaps(member),
                        let diff = range.difference(member) {
                    storage[index] = diff
                    return member
                }
                else if member.isSuperset(of: range) {
                    indexesToRemove.append(index)
                }
            }

            if indexesToRemove.isEmpty {
                return nil
            }
            else {
                return member
            }
        }
    }

    // MARK: - Combining Sets

    func union(_ other: Self) -> Self {
        var union = self
        union.formUnion(other)
        return union
    }

    mutating func formUnion(_ other: Self) {
        other.storage.forEach { insert($0) }
    }

    func intersection(_ other: Self) -> Self {
        product(storage, other.storage)
            .compactMap { $0.intersection($1) }
            .reduce(into: Self()) { $0.insert($1) }
    }

    mutating func formIntersection(_ other: Self) {
        self = intersection(other)
    }

    func symmetricDifference(_ other: Self) -> Self {
        var diff = self
        diff.formSymmetricDifference(other)
        return diff
    }

    mutating func formSymmetricDifference(_ other: Self) {
        var indexesToRemove: [Int] = []
        defer {
            for index in indexesToRemove {
                storage.remove(at: index)
            }
        }

        for ((index, range), other) in product(storage.indexed(),
                                               other.storage) {
            if other.isSuperset(of: range) {
                indexesToRemove.append(index)
            }
            else if range.overlaps(other), let diff = range.difference(other) {
                storage[index] = diff
            }
        }
    }

}
