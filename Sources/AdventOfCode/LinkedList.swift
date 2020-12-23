//
//  LinkedList.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/23/20.
//

import Foundation

struct LinkedList<Element>: Sequence {

    class Node {
        let value: Element
        var next: Node?

        init(_ value: Element, next: Node?) {
            self.value = value
            self.next = next
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

    private(set) var count: Int = 0

    subscript(index: Int) -> Node? {
        var element = first

        for _ in 0 ..< index {
            element = element?.next
        }

        return element
    }

    func makeIterator() -> Iterator {
        Iterator(node: first)
    }

    mutating func pop() -> Element? {
        guard let first = first else { return nil }

        self.first = first.next
        count -= 1

        return first.value
    }

    mutating func push(_ newValue: Element) {
        first = Node(newValue, next: first)
        count += 1
    }

}

extension LinkedList {

    init<T: Sequence>(_ sequence: T) where T.Iterator.Element == Element {
        self.init()

        for element in sequence.reversed() {
            push(element)
        }
    }

}

extension LinkedList where Element: Equatable {

    func firstNode(of element: Element) -> Node? {
        var node = first

        while node != nil {
            if node?.value == element { return node }
            node = node?.next
        }

        return nil
    }

}

extension LinkedList where Element: Hashable {

    func generateSearchDict() -> [Element: Node] {
        var dict: [Element: Node] = [:]

        var node = first

        while node != nil {
            dict[node!.value] = node!
            node = node?.next
        }

        return dict
    }

}
