//
//  2DDirections.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation

enum MapDirection {
    case north
    case south
    case west
    case east
}

enum MovementDirection: String, CaseIterable {
    case up
    case down
    case left
    case right
}

enum TurnDirection {
    case left
    case right
}

func + (_ lhs: MapDirection, _ rhs: TurnDirection) -> MapDirection {
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

func + (_ lhs: MovementDirection, _ rhs: TurnDirection) -> MovementDirection {
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

func + <T>(lhs: Point2D<T>, rhs: MovementDirection) -> Point2D<T> {
    switch rhs {
    case .up: return Point2D(x: lhs.x, y: lhs.y + 1)
    case .down: return Point2D(x: lhs.x, y: lhs.y - 1)
    case .left: return Point2D(x: lhs.x - 1, y: lhs.y)
    case .right: return Point2D(x: lhs.x + 1, y: lhs.y)
    }
}
