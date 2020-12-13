//
//  CollectionConcurrency.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/13/20.
//

import Foundation

extension Sequence {

    private func forEachConcurrentDispatch(
        queue: DispatchQueue,
        group: DispatchGroup,
        maxConcurrentOperations: Int,
        body: @escaping (Element) -> Bool
    ) {
        var stop = false

        let semaphore = DispatchSemaphore(value: maxConcurrentOperations)

        let stopQueue = DispatchQueue(label: "stop", attributes: .concurrent)

        for element in self {
            semaphore.wait()
            if stopQueue.sync(execute: { stop }) {
                semaphore.signal()
                break
            }

            group.enter()

            queue.async {
                if body(element) {
                    stopQueue.async(flags: .barrier) {
                        stop = true
                    }
                }
                semaphore.signal()
                group.leave()
            }
        }
    }

    func forEachConcurrent(
        onQueue queue: DispatchQueue = .global(),
        maxConcurrentOperations: Int = ProcessInfo().activeProcessorCount,
        _ body: @escaping (Element) -> Bool
    ) {
        let group = DispatchGroup()

        forEachConcurrentDispatch(
            queue: queue,
            group: group,
            maxConcurrentOperations: maxConcurrentOperations,
            body: body
        )

        group.wait()
    }

    @discardableResult
    func forEachConcurrent(
        onQueue queue: DispatchQueue = .global(),
        timeout: DispatchTime,
        maxConcurrentOperations: Int = ProcessInfo().activeProcessorCount,
        _ body: @escaping (Element) -> Bool
    ) -> DispatchTimeoutResult {
        let group = DispatchGroup()

        forEachConcurrentDispatch(
            queue: queue,
            group: group,
            maxConcurrentOperations: maxConcurrentOperations,
            body: body
        )

        return group.wait(timeout: timeout)
    }

    @discardableResult
    func forEachConcurrent(
        onQueue queue: DispatchQueue = .global(),
        wallTimeout timeout: DispatchWallTime,
        maxConcurrentOperations: Int = ProcessInfo().activeProcessorCount,
        _ body: @escaping (Element) -> Bool
    ) -> DispatchTimeoutResult {
        let group = DispatchGroup()

        forEachConcurrentDispatch(
            queue: queue,
            group: group,
            maxConcurrentOperations: maxConcurrentOperations,
            body: body
        )

        return group.wait(wallTimeout: timeout)
    }

}
