//
//  2020Day20.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/20/20.
//

// swiftlint:disable file_length

import Algorithms
import Foundation
import IsNotEmpty

private let exampleInput =
    """
    Tile 2311:
    ..##.#..#.
    ##..#.....
    #...##..#.
    ####.#...#
    ##.##.###.
    ##...#.###
    .#.#.#..##
    ..#....#..
    ###...#.#.
    ..###..###

    Tile 1951:
    #.##...##.
    #.####...#
    .....#..##
    #...######
    .##.#....#
    .###.#####
    ###.##.##.
    .###....#.
    ..#.#..#.#
    #...##.#..

    Tile 1171:
    ####...##.
    #..##.#..#
    ##.#..#.#.
    .###.####.
    ..###.####
    .##....##.
    .#...####.
    #.##.####.
    ####..#...
    .....##...

    Tile 1427:
    ###.##.#..
    .#..#.##..
    .#.##.#..#
    #.#.#.##.#
    ....#...##
    ...##..##.
    ...#.#####
    .#.####.#.
    ..#..###.#
    ..##.#..#.

    Tile 1489:
    ##.#.#....
    ..##...#..
    .##..##...
    ..#...#...
    #####...#.
    #..#.#.#.#
    ...#.#.#..
    ##.#...##.
    ..##.##.##
    ###.##.#..

    Tile 2473:
    #....####.
    #..#.##...
    #.##..#...
    ######.#.#
    .#...#.#.#
    .#########
    .###.#..#.
    ########.#
    ##...##.#.
    ..###.#.#.

    Tile 2971:
    ..#.#....#
    #...###...
    #.#.###...
    ##.##..#..
    .#####..##
    .#..####.#
    #..#.#..#.
    ..####.###
    ..#.#.###.
    ...#.#.#.#

    Tile 2729:
    ...#.#.#.#
    ####.#....
    ..#.#.....
    ....#..#.#
    .##..##.#.
    .#.####...
    ####.#.#..
    ##.####...
    ##..#.##..
    #.##...##.

    Tile 3079:
    #.#.#####.
    .#..######
    ..#.......
    ######....
    ####.#..#.
    .#...#.##.
    #.#####.##
    ..#.###...
    ..#.......
    ..#.###...
    """

private let seaMonster =
    """
                      #
    #    ##    ##    ###
     #  #  #  #  #  #
    """

extension Year2020 {

    public enum Day20: FullPuzzle {

        public static let year: Year.Type = Year2020.self

        public static let day = 20

        enum Rotation: CaseIterable, CustomStringConvertible, Hashable {
            case none
            case rotate90
            case rotate180
            case rotate270

            var description: String {
                switch self {
                case .none: return "not rotated"
                case .rotate90: return "rotated 90º"
                case .rotate180: return "rotated 180º"
                case .rotate270: return "rotated 270º"
                }
            }
        }

        struct Transform: CaseIterable, CustomStringConvertible, Hashable {
            let flipped: Bool
            let rotation: Rotation

            static let identity = Transform(flipped: false, rotation: .none)

            static var allCases: [Transform] {
                product([true, false], Rotation.allCases).map(Transform.init)
            }

            var description: String {
                switch (flipped, rotation) {
                case (false, .none): return "as-is"
                case let (false, rotation): return rotation.description
                case (true, .none): return "flipped"
                case let (true, rotation):
                    return "flipped and \(rotation)"
                }
            }
        }

        enum Side: String, CaseIterable, Equatable, Hashable {
            case top
            case bottom
            case left
            case right

            var opposite: Side {
                switch self {
                case .top: return .bottom
                case .bottom: return .top
                case .left: return .right
                case .right: return .left
                }
            }
        }

        struct Tile: CustomStringConvertible, Hashable {
            let id: Int
            let data: Matrix<Character>

            init(id: Int, data: Matrix<Character>) {
                self.id = id
                self.data = data
            }

            init(id: Int, data: [[Character]]) {
                self.id = id
                self.data = Matrix(items: data)
            }

            init?(string: String) {
                var lines = string.components(separatedBy: .newlines)

                guard lines.count == 11 else { return nil }

                var header = lines.removeFirst()
                header.removeFirst(5)
                header.removeLast()

                guard let id = Int(header) else { return nil }

                self.init(id: id, data: lines.map { Array($0) })
            }

            var description: String {
                "Tile \(id):\n" + data.rows
                    .map { String($0) }
                    .joined(separator: "\n")
            }

            subscript(side: Side) -> [Character] {
                self.pattern(for: side)
            }

            func apply(_ transform: Transform) -> Tile {
                if transform == .identity { return self }

                var newData = data

                if transform.flipped { newData.flipHorizontal() }

                switch transform.rotation {
                case .none: break
                case .rotate90: newData.rotate(times: 1)
                case .rotate180: newData.rotate(times: 2)
                case .rotate270: newData.rotate(times: 3)
                }

                guard newData.storage.count == data.storage.count else {
                    preconditionFailure()
                }

                return Tile(id: id, data: newData)
            }

            func variations() -> [(Tile, Transform)] {
                Transform.allCases.map { transform in
                    (self.apply(transform), transform)
                }
            }

            func matches(for side: Side,
                         in tiles: [Tile]) -> [(Tile, Transform)] {
                let pattern = self.pattern(for: side)

                var matches: [(Tile, Transform)] = []

                for tile in tiles where tile.id != id {
                    for transform in Transform.allCases {
                        let transformedTile = tile.apply(transform)
                        let tilePattern = transformedTile[side.opposite]

                        if pattern == tilePattern {
                            // swiftlint:disable:next line_length
                            log("Tile \(id)’s \(side) side (\(String(pattern))) matches tile \(tile.id)’s \(side.opposite) side (\(String(tilePattern))) with transform \(transform)")

                            matches.append((transformedTile, transform))
                        }
                    }
                }

                return matches
            }

            func pattern(for side: Side) -> [Character] {
                switch side {
                case .top: return data.rows.first!
                case .bottom: return data.rows.last!
                case .left: return data.columns.first!
                case .right: return data.columns.last!
                }
            }

        }

        static func tile(for id: Int, in tiles: [Tile]) -> Tile? {
            tiles.first { $0.id == id }
        }

        private static func cornerPieces(in tiles: [Tile]) -> [Tile] {
            var corners: [Tile] = []

            for tile in tiles {
                var sidesWithMatches = 0

                for side in Side.allCases {
                    if tile.matches(for: side, in: tiles).isEmpty {
                        log("Tile \(tile.id) has no matches on its \(side).")
                        sidesWithMatches += 1
                    }
                }

                if sidesWithMatches == 2 {
                    corners.append(tile)
                }
            }

            return corners
        }

        public static func example1() -> String {
            let tiles = exampleInput.components(separatedBy: "\n\n")
                .compactMap(Tile.init)

            return "\(cornerPieces(in: tiles).map(\.id).productOfElements())"
        }

        public static func part1() -> String {
            let tiles = puzzleInput().components(separatedBy: "\n\n")
                .compactMap(Tile.init)

            return "\(cornerPieces(in: tiles).map(\.id).productOfElements())"
        }

        // swiftlint:disable:next function_body_length
        private static func constructPuzzle(
            from tiles: [Tile]
        ) -> Matrix<Tile> {
            var tiles = tiles
            let cornerPieces = self.cornerPieces(in: tiles)

            guard let start = cornerPieces.first else { preconditionFailure() }

            let finalSize = Int(sqrt(Double(tiles.count)))

            var finalPieces = Matrix<Tile?>(size: finalSize, repeating: nil)

            guard let (topLeftTile, transform) = start.variations()
                    .first(where: {
                        $0.0.matches(for: .top, in: tiles).isEmpty &&
                            $0.0.matches(for: .left, in: tiles).isEmpty
                    })
            else { preconditionFailure() }

            var row = 0
            var column = 0

            // swiftlint:disable:next line_length
            log("Added tile \(topLeftTile.id) at position \(row), \(column) \(transform)")

            finalPieces[0, 0] = topLeftTile
            var foundPieces = 1
            column += 1

            tiles.remove(at: tiles.firstIndex { $0.id == topLeftTile.id }!)

            while foundPieces < finalSize * finalSize {
                if column == 0 {
                    guard let tile = finalPieces[row - 1, column],
                          let (nextTile, transform) = tile.matches(
                            for: .bottom, in: tiles
                          ).first
                    else { preconditionFailure() }

                    finalPieces[row, column] = nextTile

                    // swiftlint:disable:next line_length
                    log("Added tile \(nextTile.id) at position \(row), \(column) \(transform)")

                    column += 1
                    foundPieces += 1
                    tiles.remove(at: tiles.firstIndex { $0.id == nextTile.id }!)

                }
                else if column < finalSize {
                    guard let tile = finalPieces[row, column - 1],
                          let (nextTile, transform) = tile.matches(
                            for: .right, in: tiles
                          ).first
                    else { preconditionFailure() }

                    // swiftlint:disable:next line_length
                    log("Added tile \(nextTile.id) at position \(row), \(column) \(transform)")
                    finalPieces[row, column] = nextTile
                    column += 1
                    foundPieces += 1
                    tiles.remove(at: tiles.firstIndex { $0.id == nextTile.id }!)
                }
                else {
                    row += 1
                    column = 0
                }
            }

            return finalPieces.map { $0! }
        }

        private static func startIndexesOfSeaMonsters(
            in map: Matrix<Character>
        ) -> [Matrix<Character>.Index] {
            var seaMonsterSearch: [(Matrix<Character>.Index, Character)] = []

            for (row, line) in seaMonster
                .components(separatedBy: .newlines)
                .enumerated() {
                for (col, char) in Array(line).enumerated() where char == "#" {
                    let index = Matrix<Character>.Index(row: row, column: col)
                    seaMonsterSearch.append((index, char))
                }
            }

            return map.indexes(of: seaMonsterSearch)
        }

        private static func nonSeaMonsterCount(_ tiles: [Tile]) -> Int {
            let solved = constructPuzzle(from: tiles)
                .map { $0.data }
                .map { $0.inset(1) }
                .reduce()

            let seaMonsterCount =
                product([false, true], (0...3)).map { flipped, rotations in
                    var map = solved

                    if flipped {
                        map.flipHorizontal()
                    }

                    map.rotate(times: rotations)

                    return map
                }
                .lazy
                .map { startIndexesOfSeaMonsters(in: $0) }
                .filter(\.isNotEmpty)
                .first
                .map(\.count) ?? 0

            return solved.count(of: "#") -
                seaMonsterCount * seaMonster.count(of: "#")
        }

        public static func example2() -> String {
            let tiles = exampleInput.components(separatedBy: "\n\n")
                .compactMap(Tile.init)

            return "\(nonSeaMonsterCount(tiles))"
        }

        public static func part2() -> String {
            let tiles = puzzleInput().components(separatedBy: "\n\n")
                .compactMap(Tile.init)

            return "\(nonSeaMonsterCount(tiles))"
        }

    }

}
