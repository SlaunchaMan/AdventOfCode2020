//
//  2016Day22.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/23/20.
//

 import Algorithms
 import Foundation
 import StringDecoder

 private let exampleInput =
    """
    Filesystem            Size  Used  Avail  Use%
    /dev/grid/node-x0-y0   10T    8T     2T   80%
    /dev/grid/node-x0-y1   11T    6T     5T   54%
    /dev/grid/node-x0-y2   32T   28T     4T   87%
    /dev/grid/node-x1-y0    9T    7T     2T   77%
    /dev/grid/node-x1-y1    8T    0T     8T    0%
    /dev/grid/node-x1-y2   11T    7T     4T   63%
    /dev/grid/node-x2-y0   10T    6T     4T   60%
    /dev/grid/node-x2-y1    9T    8T     1T   88%
    /dev/grid/node-x2-y2    9T    6T     3T   66%
    """

 extension Year2016 {

    public enum Day22: PuzzleWithExample2 {

        public static let year: Year.Type = Year2016.self

        public static let day = 22

        typealias Point = Point2D<UInt8>

        struct Node: Decodable, Equatable, Hashable {
            let point: Point
            let size: UInt16
            var used: UInt16
            var available: UInt16
            var usePercent: UInt8

            enum CodingKeys: String, CodingKey {
                case x
                case y
                case size = "Size"
                case used = "Used"
                case available = "Avail"
                case usePercent = "Use"
            }

            var isTargetNode = false

            func canTransferData(toNode node: Node) -> Bool {
                node.available >= used
            }

            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)

                let x = try container.decode(UInt8.self, forKey: .x)
                let y = try container.decode(UInt8.self, forKey: .y)
                point = Point(x: x, y: y)

                size = try container.decode(UInt16.self, forKey: .size)
                used = try container.decode(UInt16.self, forKey: .used)

                available = try container.decode(UInt16.self,
                                                 forKey: .available)

                usePercent = try container.decode(UInt8.self,
                                                  forKey: .usePercent)
            }
        }

        private static let nodeDecoder = StringDecoder(
            // swiftlint:disable:next line_length
            formatString: "\\/dev\\/grid\\/node\\-x$(x)\\-y$(y)( +)$(Size)T( +)$(Used)T( +)$(Avail)T( +)$(Use)\\%"
        )

        public static func part1() -> String {
            let nodes = parseInputLines(puzzleInput())
                .dropFirst(2)
                .compactMap { line -> Node? in
                    do {
                        return try nodeDecoder.decode(Node.self, from: line)
                    }
                    catch {
                        log(error)
                        return nil
                    }
                }

            let viablePairs = nodes.permutations(ofCount: 2)
                .filter { $0[0].used != 0 }
                .filter { $0[0].canTransferData(toNode: $0[1]) }

            return "\(viablePairs.count)"
        }

        private static func node(at point: Point,
                                 in nodes: [Node]) -> Node? {
            nodes.first { node in
                node.point == point
            }
        }

        private static func neighbors(of point: Point,
                                      in nodes: [Node],
                                      maxX: Point.Unit,
                                      maxY: Point.Unit) -> [Node] {
            point.directNeighbors()
                .filter { $0.x <= maxX }
                .filter { $0.y <= maxY}
                .compactMap { point in
                    node(at: point, in: nodes)
                }
        }

        private static func state(_ state: [Node],
                                  movingDataFromNode sourceNode: Node,
                                  toNode destinationNode: Node) -> [Node] {
            guard let sourceIndex = state.firstIndex(of: sourceNode),
                  let destinationIndex = state.firstIndex(of: destinationNode),
                  sourceNode.canTransferData(toNode: destinationNode)
            else { preconditionFailure() }

            var sourceNode = sourceNode
            var destinationNode = destinationNode

            destinationNode.available -= sourceNode.used
            destinationNode.isTargetNode = sourceNode.isTargetNode
            destinationNode.used += sourceNode.used
            destinationNode.usePercent = UInt8((100 * destinationNode.used) /
                                                destinationNode.size)

            sourceNode.available = sourceNode.size
            sourceNode.isTargetNode = false
            sourceNode.used = 0
            sourceNode.usePercent = 0

            var state = state
            state[sourceIndex] = sourceNode
            state[destinationIndex] = destinationNode
            return state
        }

        private static func leastNumberOfMoves(nodes: [Node]) -> Int {
            var nodes = nodes

            guard let maxX = nodes.map(\.point).map(\.x).max(),
                  let maxY = nodes.map(\.point).map(\.y).max()
            else { preconditionFailure() }

            guard let targetNodeIndex = nodes.firstIndex(
                where: { $0.point == Point(x: maxX, y: 0) }
            ) else { preconditionFailure() }

            nodes[targetNodeIndex].isTargetNode = true

            func destinationNode() -> Node? {
                node(at: .origin, in: nodes)
            }

            var currentState: Set<[Node]> = [nodes]
            var history: Set<[Node]> = currentState
            var iterations = 0

            repeat {
                var nextState: Set<[Node]> = []

                for nodes in currentState {
                    guard let emptyNode = nodes.first(where: { $0.used == 0 })
                    else { continue }

                    let nextChoices: [Node] = self.neighbors(
                        of: emptyNode.point,
                        in: nodes,
                        maxX: maxX,
                        maxY: maxY
                    )

                    nextChoices
                        .filter { $0.canTransferData(toNode: emptyNode) }
                        .map {
                            state(nodes,
                                  movingDataFromNode: $0,
                                  toNode: emptyNode)
                        }
                        .filter { !history.contains($0) }
                        .forEach {
                            nextState.insert($0)
                            history.insert($0)
                        }
                }

                currentState = nextState
                iterations += 1
                // swiftlint:disable:next line_length
                log("After \(iterations) iterations, currentState contains \(currentState.count) variations")
            } while !currentState.contains(
                where: { node(at: .origin, in: $0)!.isTargetNode }
            )

            return iterations
        }

        public static func example2() -> String {
            let nodes = parseInputLines(exampleInput)
                .dropFirst()
                .compactMap { line -> Node? in
                    do {
                        return try nodeDecoder.decode(Node.self, from: line)
                    }
                    catch {
                        log(error)
                        return nil
                    }
                }

            return "\(leastNumberOfMoves(nodes: nodes))"
        }

        public static func part2() -> String {
            let nodes = parseInputLines(puzzleInput())
                .dropFirst(2)
                .compactMap { line -> Node? in
                    do {
                        return try nodeDecoder.decode(Node.self, from: line)
                    }
                    catch {
                        log(error)
                        return nil
                    }
                }

            return "\(leastNumberOfMoves(nodes: nodes))"
        }

    }

 }
