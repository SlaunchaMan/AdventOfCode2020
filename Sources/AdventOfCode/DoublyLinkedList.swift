//
//  DoublyLinkedList.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/22/20.
//

import Foundation

struct DoublyLinkedList<Element>: Sequence {

    class Node {
        var value: Element
        fileprivate(set) var next: Node?
        fileprivate(set) var previous: Node?

        init(_ value: Element, next: Node?, previous: Node?) {
            self.value = value
            self.next = next
            self.previous = previous

            next?.previous = self
            previous?.next = self
        }
    }

    struct Iterator: IteratorProtocol {

        var node: Node?

        mutating func next() -> Element? {
            let value = node?.value
            node = node?.next
            return value
        }

    }

    private(set) var first: Node?
    private(set) var last: Node?

    private(set) var count: Int = 0

    subscript(index: Int) -> Node? {
        precondition(index < count)

        var element = first

        for _ in 0 ..< index {
            element = element?.next
        }

        return element
    }

    func makeIterator() -> Iterator {
        Iterator(node: first)
    }

    mutating func popFirst() -> Element? {
        guard let first = first else { return nil }

        self.first = first.next
        self.first?.previous = first.previous
        first.previous?.next = self.first

        count -= 1

        return first.value
    }

    mutating func popLast() -> Element? {
        guard let last = last else { return nil }

        self.last = last.previous
        self.last?.next = last.next
        last.next?.previous = self.last

        count -= 1

        return last.value
    }

    mutating func pushFirst(_ element: Element) {
        last = Node(element, next: first, previous: nil)

        if last == nil {
            last = first
        }

        count += 1
    }

    mutating func pushLast(_ element: Element) {
        last = Node(element, next: nil, previous: last)

        if first == nil {
            first = last
        }

        count += 1
    }

    mutating func remove(_ node: Node) {
        node.next?.previous = node.previous
        node.previous?.next = node.next

        if first === node {
            first = node.next
        }

        if last === node {
            last = node.next
        }

        count -= 1
    }

}

extension DoublyLinkedList {

    init<T: Sequence>(_ sequence: T, circular: Bool = false)
    where T.Iterator.Element == Element {
        self.init()

        for next in sequence {
            pushLast(next)
        }
    }

}
