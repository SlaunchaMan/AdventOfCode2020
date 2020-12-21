//
//  Matrix.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/20/20.
//

import Foundation

struct Matrix<Element> {

    struct Index: Hashable {
        let row: Int
        let column: Int
    }

    let size: Int
    var storage: [Element]

    init(items: [Element]) {
        let size = Int(sqrt(Double(items.count)))

        precondition(
            items.count == size * size,
            "Matrix must have a square number of items (got \(items.count))."
        )

        self.size = size
        self.storage = items
    }

    init(items: [[Element]]) {
        self.init(items: items.flatMap { $0 })
    }

    init(size: Int, repeating item: Element) {
        self.init(items: [Element](repeating: item, count: size * size))
    }

    private func index(forRow row: Int, column: Int) -> Int {
        (row * size) + column
    }

    subscript(index: Index) -> Element {
        get { self[index.row, index.column] }
        set { self[index.row, index.column] = newValue }
    }

    subscript(row: Int, column: Int) -> Element {
        get { storage[index(forRow: row, column: column)] }
        set { storage[index(forRow: row, column: column)] = newValue}
    }

    mutating func flipHorizontal() {
        for i in stride(from: 0, to: (size * size), by: size) {
            storage.reverse(subrange: i ..< (i + size))
        }
    }

    mutating func rotate(times n: Int) {
        for _ in 0 ..< n {
            var newStorage: [Element] = []

            for column in 0 ..< size {
                for row in 0 ..< size {
                    newStorage.append(self[size - row - 1, column])
                }
            }

            storage = newStorage
        }
    }

    var rows: [[Element]] {
        storage.chunked(into: size)
    }

    var columns: [[Element]] {
        (0 ..< size).map { column in
            (0 ..< size).map { row in
                self[row, column]
            }
        }
    }

    func map<T>(_ transform: (Element) throws -> T) rethrows -> Matrix<T> {
        try Matrix<T>(items: storage.map(transform))
    }

    func compactMap<T>(_ transform: (Element) throws -> T?) rethrows -> [T] {
        try storage.compactMap(transform)
    }

    func reduce<T>() -> Matrix<T> where Element == Matrix<T> {
        let innerSize = storage[0].size
        precondition(storage.allSatisfy { $0.size == innerSize },
                     "Attempted to reduce a matrix of unequally-sized matrices")

        var newElements: [T] = []

        for row in 0 ..< size * innerSize {
            for column in 0 ..< size * innerSize {
                let (outerRow, innerRow) = row
                    .quotientAndRemainder(dividingBy: innerSize)

                let (outerColumn, innerColumn) = column
                    .quotientAndRemainder(dividingBy: innerSize)

                newElements.append(
                    self[outerRow, outerColumn][innerRow, innerColumn]
                )
            }
        }

        return Matrix<T>(items: newElements)
    }

    func inset(_ n: Int) -> Self {
        precondition(size - n - n > 0)

        var newElements: [Element] = []

        for row in n ..< size - n {
            for column in n ..< size - n {
                newElements.append(self[row, column])
            }
        }

        return Matrix(items: newElements)
    }
}

extension Matrix: CustomStringConvertible
where Element: CustomStringConvertible {

    var description: String {
        rows.map { $0.map(\.description).joined() }.joined(separator: "\n")
    }

}

extension Matrix: Equatable where Element: Equatable {

    static func == (lhs: Matrix<Element>, rhs: Matrix<Element>) -> Bool {
        lhs.storage == rhs.storage
    }

    func count(of element: Element) -> Int {
        storage.count(of: element)
    }

    func indexes(of search: [(offset: Index, element: Element)]) -> [Index] {
        guard let maxWidth = search.map({ $0.offset.column }).max(),
              let maxHeight = search.map({ $0.offset.row }).max(),
              size >= max(maxWidth, maxHeight)
        else { return [] }

        var indexes: [Index] = []

        for row in 0 ..< size - maxHeight {
            for column in 0 ..< size - maxWidth {
                if search.allSatisfy({ (offset, element) in
                    self[row + offset.row, column + offset.column] == element
                }) {
                    indexes.append(Index(row: row, column: column))
                }
            }
        }

        return indexes
    }

}

extension Matrix: Hashable where Element: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(storage)
    }

}

extension Matrix.Index: CustomStringConvertible {

    var description: String { "(\(row), \(column))" }

}
