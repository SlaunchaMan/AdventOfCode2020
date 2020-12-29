//
//  ConcurrentIteration.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/28/20.
//

import Foundation

private class ConcurrentIterator<Iterator: IteratorProtocol> {

    private var iterator: Iterator
    private var shouldStop = false
    private let queueForEnqueueing = DispatchQueue(label: "ConcurrentIterator")
    private let queueForEvaluating: DispatchQueue

    let semaphore = DispatchSemaphore(value: 0)

    init(iterator: Iterator, queue: DispatchQueue) {
        self.iterator = iterator
        queueForEvaluating = queue
    }

    convenience init(iterator: Iterator, qos: DispatchQoS = .default) {
        self.init(
            iterator: iterator,
            queue: DispatchQueue(
                label: "AdventOfCode.ConcurrentIterator",
                qos: qos,
                attributes: .concurrent,
                autoreleaseFrequency: .workItem,
                target: nil
            )
        )
    }

    private func enqueueNext(
        index: Int = 0,
        evaluate block: @escaping (Int, Iterator.Element) -> Bool
    ) {
        dispatchPrecondition(condition: .onQueue(queueForEnqueueing))

        guard !shouldStop, let next = iterator.next() else {
            semaphore.signal()
            return
        }

        queueForEvaluating.async {
            if block(index, next) {
                self.queueForEnqueueing.async {
                    self.shouldStop = true
                }
            }
        }

        self.queueForEnqueueing.async {
            self.enqueueNext(evaluate: block)
        }
    }

    func begin(evaluate block: @escaping (Int, Iterator.Element) -> Bool) {
        queueForEnqueueing.async {
            self.enqueueNext(evaluate: block)
        }
    }

}

extension Sequence {

    func concurrentFirst(
        where predicate: @escaping (Element) -> Bool
    ) -> Element? {
        let iterator = ConcurrentIterator(iterator: makeIterator())

        let matchQueue = DispatchQueue(label: "AdventOfCode.concurrentFirst")
        var match: (Int, Element)?

        iterator.begin { (index, element) -> Bool in
            if predicate(element) {
                matchQueue.async {
                    if match?.0 ?? -1 < index {
                        match = (index, element)
                    }
                }

                return true
            }

            return false
        }

        iterator.semaphore.wait()

        return matchQueue.sync { match?.1 }
    }

}
