//
//  NDimensionGeometry.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/17/20.
//

import Algorithms
import Foundation

// MARK: - Points

protocol NDimensionPoint {
    associatedtype Unit: Numeric
    init(x: Unit, y: Unit)
}

protocol Neighbors: Hashable {
    func neighbors() -> Set<Self>
}

// MARK: - 2-Dimensional Points

struct Point2D<Unit: Numeric> {

    var x: Unit
    var y: Unit

    static var origin: Point2D {
        Point2D(x: .zero, y: .zero)
    }

}

extension Point2D: NDimensionPoint {}

extension Point2D: CustomStringConvertible {

    var description: String {
        "(\(x), \(y))"
    }

}

extension Point2D: CustomDebugStringConvertible {

    var debugDescription: String {
        "\(String(describing: Unit.self)) point: \(description)"
    }

}

extension Point2D: Equatable where Unit: Equatable {}
extension Point2D: Hashable where Unit: Hashable {}

extension Point2D: ExpressibleByArrayLiteral
where Unit: ExpressibleByIntegerLiteral {

    typealias ArrayLiteralElement = Unit.IntegerLiteralType

    init(arrayLiteral elements: ArrayLiteralElement...) {
        x = Unit.init(integerLiteral: elements[0])
        y = Unit.init(integerLiteral: elements[1])
    }

}

extension Point2D: Neighbors where Unit: Hashable {

    func neighbors() -> Set<Point2D> {
        Set(
            product(-1...1, -1...1).map { x, y in
                return Point2D(x: self.x + Unit(exactly: x)!,
                               y: self.y + Unit(exactly: y)!)
            }
            .filter { $0 != self }
        )
    }

}

extension Point2D where Unit: SignedNumeric {

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

extension Point2D where Unit: SignedNumeric, Unit: Comparable {

    func manhattanDistance(to point: Point2D) -> Unit {
        abs(x - point.x) + abs(y - point.y)
    }

}

// MARK: - 3-Dimensional Points

struct Point3D<Unit: Numeric> {
    let x: Unit
    let y: Unit
    let z: Unit
}

extension Point3D: NDimensionPoint {

    init(x: Unit, y: Unit) {
        self.x = x
        self.y = y
        z = .zero
    }

}

extension Point3D: CustomStringConvertible {

    var description: String { "(\(x), \(y), \(z))" }

}

extension Point3D: CustomDebugStringConvertible {

    var debugDescription: String {
        "\(String(describing: Unit.self)) point: \(description)"
    }

}

extension Point3D: Equatable where Unit: Equatable {}
extension Point3D: Hashable where Unit: Hashable {}

extension Point3D: ExpressibleByArrayLiteral
where Unit: ExpressibleByIntegerLiteral {

    typealias ArrayLiteralElement = Unit.IntegerLiteralType

    init(arrayLiteral elements: ArrayLiteralElement...) {
        x = Unit.init(integerLiteral: elements[0])
        y = Unit.init(integerLiteral: elements[1])
        z = Unit.init(integerLiteral: elements[2])
    }

}

extension Point3D: Neighbors where Unit: Hashable {

    func neighbors() -> Set<Point3D> {
        Set(
            product(product(-1...1, -1...1), -1...1).map { (arg0, z) in
                let (x, y) = arg0

                return Point3D(x: self.x + Unit(exactly: x)!,
                               y: self.y + Unit(exactly: y)!,
                               z: self.z + Unit(exactly: z)!)
            }
            .filter { $0 != self }
        )
    }

}

// MARK: - 4-Dimensional Points

struct Point4D<Unit: Numeric> {
    let x: Unit
    let y: Unit
    let z: Unit
    let w: Unit
}

extension Point4D: NDimensionPoint {
    init(x: Unit, y: Unit) {
        self.x = x
        self.y = y
        z = .zero
        w = .zero
    }
}

extension Point4D: CustomStringConvertible {
    var description: String { "(\(x), \(y), \(z), \(w))"}
}

extension Point4D: CustomDebugStringConvertible {

    var debugDescription: String {
        "\(String(describing: Unit.self)) point: \(description)"
    }

}

extension Point4D: Equatable where Unit: Equatable {}
extension Point4D: Hashable where Unit: Hashable {}

extension Point4D: ExpressibleByArrayLiteral
where Unit: ExpressibleByIntegerLiteral {

    typealias ArrayLiteralElement = Unit.IntegerLiteralType

    init(arrayLiteral elements: ArrayLiteralElement...) {
        x = Unit.init(integerLiteral: elements[0])
        y = Unit.init(integerLiteral: elements[1])
        z = Unit.init(integerLiteral: elements[2])
        w = Unit.init(integerLiteral: elements[3])
    }

}

extension Point4D: Neighbors where Unit: Hashable {

    func neighbors() -> Set<Point4D> {
        Set(
            product(product(-1...1, -1...1),
                    product(-1...1, -1...1))
                .map { (arg0, arg1) in
                    let (x, y) = arg0
                    let (z, w) = arg1

                    return Point4D(x: self.x + Unit(exactly: x)!,
                                   y: self.y + Unit(exactly: y)!,
                                   z: self.z + Unit(exactly: z)!,
                                   w: self.w + Unit(exactly: w)!)
                }
                .filter { $0 != self }
        )
    }

}

// MARK: - Bounds

protocol NDimensionPointBounds {
    associatedtype Point: NDimensionPoint
    func isIncluded(_ point: Point) -> Bool
}

// MARK: - 2-Dimensional Bounds

struct PointBounds2D<Unit: Numeric>: NDimensionPointBounds
where Unit: Comparable {

    let validX: Range<Unit>
    let validY: Range<Unit>

    func isIncluded(_ point: Point2D<Unit>) -> Bool {
        validX.contains(point.x) && validY.contains(point.y)
    }

}

// MARK: - 3-Dimensional Bounds

struct PointBounds3D<Unit: Numeric>: NDimensionPointBounds
where Unit: Comparable {

    let validX: Range<Unit>
    let validY: Range<Unit>
    let validZ: Range<Unit>

    func isIncluded(_ point: Point3D<Unit>) -> Bool {
        validX.contains(point.x) &&
            validY.contains(point.y) &&
            validZ.contains(point.z)
    }

}

// MARK: - 4-Dimensional Bounds

struct PointBounds4D<Unit: Numeric>: NDimensionPointBounds
where Unit: Comparable {

    let validX: Range<Unit>
    let validY: Range<Unit>
    let validZ: Range<Unit>
    let validW: Range<Unit>

    func isIncluded(_ point: Point4D<Unit>) -> Bool {
        validX.contains(point.x) &&
            validY.contains(point.y) &&
            validZ.contains(point.z) &&
            validW.contains(point.w)
    }

}
