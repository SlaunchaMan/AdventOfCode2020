//
//  2DGeometry.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/5/20.
//

import Foundation

struct Point<Unit: Numeric> {

    var x: Unit
    var y: Unit

    static var origin: Point {
        Point(x: 0, y: 0)
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
