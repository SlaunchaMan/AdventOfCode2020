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

enum HorizontalDirection {
    case left
    case right
}

enum VerticalDirection {
    case up
    case down
}

enum OneOrBothOf<First, Second> {
    case first(First)
    case second(Second)
    case both(First, Second)
}

typealias Direction = OneOrBothOf<HorizontalDirection, VerticalDirection>

extension Direction {

    static let upLeft: Direction = .both(.left, .up)
    static let up: Direction = .second(.up)
    static let upRight: Direction = .both(.right, .up)
    static let left: Direction = .first(.left)
    static let right: Direction = .first(.right)
    static let downLeft: Direction = .both(.left, .down)
    static let down: Direction = .second(.down)
    static let downRight: Direction = .both(.right, .down)

}

extension OneOrBothOf: CaseIterable
where First == HorizontalDirection, Second == VerticalDirection {

    static let allCases: [Direction] = [
        .upLeft,
        .up,
        .upRight,
        .left,
        .right,
        .downLeft,
        .down,
        .downRight
    ]

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

    func position(movingTo direction: VerticalDirection,
                  from initialPosition: Position) -> Position? {
        var position = initialPosition

        switch direction {
        case .up:
            guard position.outerIndex > startIndex else { return nil }
            position.outerIndex = index(before: position.outerIndex)

        case .down:
            guard position.outerIndex < endIndex else { return nil }
            position.outerIndex = index(after: position.outerIndex)
            guard position.outerIndex < endIndex else { return nil }
        }

        return position
    }

    func position(movingTo direction: HorizontalDirection,
                  from initialPosition: Position) -> Position? {
        var position = initialPosition
        let inner = self[initialPosition.outerIndex]

        switch direction {
        case .left:
            guard position.innerIndex > inner.startIndex else { return nil }
            position.innerIndex = inner.index(before: position.innerIndex)

        case .right:
            guard position.innerIndex < inner.endIndex else { return nil }
            position.innerIndex = inner.index(after: position.innerIndex)
            guard position.innerIndex < inner.endIndex else { return nil }
        }

        return position
    }

    func position(movingTo direction: Direction,
                  from initialPosition: Position) -> Position? {
        var position = initialPosition

        // Vertical
        switch direction {
        case let .second(verticalDirection), let .both(_, verticalDirection):
            guard let next = self.position(movingTo: verticalDirection,
                                           from: position)
            else { return nil }

            position = next

        default:
            break
        }

        // Horizontal
        switch direction {
        case let .first(horizontalDirection), let .both(horizontalDirection, _):
            guard let next = self.position(movingTo: horizontalDirection,
                                           from: position)
            else { return nil }

            position = next

        default:
            break
        }

        return position
    }

    func firstVisibleNeighbors(
        of position: Position,
        skippingIndexesWhere predicate: (Element.Element) -> Bool
    ) -> [Position] {
        var neighbors: [Position] = []

        for direction in Direction.allCases {
            var nextPosition: Position? = position

            repeat {
                nextPosition = self.position(movingTo: direction,
                                             from: nextPosition!)
            } while nextPosition != nil && predicate(
                self[nextPosition!.outerIndex][nextPosition!.innerIndex]
            )

            if let nextPosition = nextPosition {
                neighbors.append(nextPosition)
            }
        }

        return neighbors
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
