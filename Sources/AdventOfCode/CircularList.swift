//
//  CircularList.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/23/20.
//

import Foundation

struct CircularList<Element>: Sequence {

    class Node {
        let value: Element
        var next: Node?
        var previous: Node?

        init(value: Element, next: Node? = nil, previous: Node? = nil) {
            self.value = value
            self.next = next
            self.previous = previous

            next?.previous = self
            previous?.next = self
        }
    }

    struct Iterator: IteratorProtocol {

        var node: Node?
        let stopAt: Node?

        init(startingAt node: Node?) {
            self.node = node
            stopAt = node
        }

        mutating func next() -> Element? {
            let value = node?.value
            node = node?.next

            if node === stopAt {
                node = nil
            }

            return value
        }

    }

    var currentNode: Node?

    subscript(offset: Int) -> Node? {
        guard currentNode != nil else { return nil }

        var node = currentNode

        for _ in 0 ..< offset {
            node = node?.next
        }

        return node
    }

    func makeIterator() -> Iterator {
        Iterator(startingAt: currentNode)
    }

    mutating func remove(node: Node) {
        node.previous?.next = node.next
        node.next?.previous = node.previous
    }

}

extension CircularList {

    init<T: Sequence>(_ sequence: T) where T.Iterator.Element == Element {
        self.init()
        var iterator = sequence.makeIterator()

        guard let first = iterator.next() else { return }

        let firstNode = Node(value: first)
        var lastNode = firstNode

        currentNode = firstNode

        while let next = iterator.next() {
            lastNode = Node(value: next, next: firstNode, previous: lastNode)
        }
    }

}

extension CircularList where Element: Equatable {

    func insert(_ element: Element, after: Element) {
        var iterator = makeIterator()

        while iterator.node?.value != after {
            _ = iterator.next()
        }

        guard let node = iterator.node else { preconditionFailure() }

        _ = Node(value: element, next: node.next, previous: node)
    }

}

extension CircularList where Element: Hashable {

    func generateSearchDict() -> [Element: Node] {
        var dict: [Element: Node] = [:]

        guard let currentNode = currentNode else { return dict }

        var node: Node? = currentNode

        repeat {
            dict[node!.value] = node
            node = node?.next
        } while node != nil && node !== currentNode

        return dict
    }

}
