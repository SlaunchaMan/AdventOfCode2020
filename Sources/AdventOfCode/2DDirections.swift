//
//  2DDirections.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation

enum TurnDirection {
    case left
    case right
}

enum MapDirection {
    case north
    case south
    case west
    case east

    static func + (_ lhs: MapDirection, _ rhs: TurnDirection) -> MapDirection {
        switch (lhs, rhs) {
        case (.north, .left): return .west
        case (.north, .right): return .east
        case (.south, .left): return .east
        case (.south, .right): return .west
        case (.west, .left): return .south
        case (.west, .right): return .north
        case (.east, .left): return .north
        case (.east, .right): return .south
        }
    }

    static func += (lhs: inout MapDirection, rhs: TurnDirection) {
        // swiftlint:disable:next shorthand_operator
        lhs = lhs + rhs
    }
}

enum MovementDirection: String, CaseIterable {
    case up
    case down
    case left
    case right

    static func + (_ lhs: MovementDirection,
                   _ rhs: TurnDirection) -> MovementDirection {
        switch (lhs, rhs) {
        case (.up, .left): return .left
        case (.up, .right): return .right
        case (.down, .left): return .right
        case (.down, .right): return .left
        case (.left, .left): return .down
        case (.left, .right): return .up
        case (.right, .left): return .up
        case (.right, .right): return .down
        }
    }

    static func += (lhs: inout MovementDirection, rhs: TurnDirection) {
        // swiftlint:disable:next shorthand_operator
        lhs = lhs + rhs
    }
}
