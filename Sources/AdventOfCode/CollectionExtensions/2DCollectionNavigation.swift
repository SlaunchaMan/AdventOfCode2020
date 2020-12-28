//
//  File.swift
//  
//
//  Created by Jeff Kelley on 12/13/20.
//

import Foundation

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

typealias Collection2DDirection = OneOrBothOf<HorizontalDirection,
                                              VerticalDirection>

extension Collection2DDirection {

    static let upLeft: Collection2DDirection = .both(.left, .up)
    static let up: Collection2DDirection = .second(.up)
    static let upRight: Collection2DDirection = .both(.right, .up)
    static let left: Collection2DDirection = .first(.left)
    static let right: Collection2DDirection = .first(.right)
    static let downLeft: Collection2DDirection = .both(.left, .down)
    static let down: Collection2DDirection = .second(.down)
    static let downRight: Collection2DDirection = .both(.right, .down)

}

extension OneOrBothOf: CaseIterable
where First == HorizontalDirection, Second == VerticalDirection {

    static let allCases: [Collection2DDirection] = [
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

    func position(movingTo direction: Collection2DDirection,
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

        for direction in Collection2DDirection.allCases {
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
