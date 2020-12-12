//
//  2DGeometry.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation

struct Point<Unit: AdditiveArithmetic> {

    var x: Unit
    var y: Unit

    static var origin: Point {
        Point(x: .zero, y: .zero)
    }

}

extension Point: CustomStringConvertible {

    var description: String {
        "(\(x), \(y))"
    }

}

extension Point: CustomDebugStringConvertible {

    var debugDescription: String {
        "\(String(describing: Unit.self)) point: \(description)"
    }

}

extension Point: Hashable where Unit: Hashable {}
extension Point: Equatable where Unit: Equatable {}

extension Point where Unit: SignedNumeric {

    mutating func rotate(clockwise: Bool) {
        if clockwise {
            let tmp = y
            y = -x
            x = tmp
        }
        else {
            let tmp = x
            x = -y
            y = tmp
        }
    }

}

extension Point where Unit: SignedNumeric, Unit: Comparable {

    func manhattanDistance(to point: Point) -> Unit {
        abs(x - point.x) + abs(y - point.y)
    }

}

enum MapDirection {
    case north
    case south
    case west
    case east
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
