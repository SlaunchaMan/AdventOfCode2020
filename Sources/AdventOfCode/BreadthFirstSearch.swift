//
//  BreadthFirstSearch.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/27/20.
//

import Foundation
import IsNotEmpty

struct BreadthFirstSearch<State: Hashable,
                          HistoryEntry: Hashable,
                          NextStateSequence: Sequence>
where NextStateSequence.Element == State {

    private let initialStates: Set<State>
    private let nextStates: (State) -> NextStateSequence
    private let isFinalState: (State) -> Bool
    private let historyTransform: (State) -> HistoryEntry

    private(set) var iterations = 0
    private var currentStates: Set<State>
    private var history: Set<HistoryEntry>

    init(
        initialStates: Set<State>,
        nextStates: @escaping (State) -> NextStateSequence,
        isFinalState: @escaping (State) -> Bool
    ) where State == HistoryEntry {
        self.init(
            initialStates: initialStates,
            nextStates: nextStates,
            isFinalState: isFinalState,
            historyTransform: { $0 }
        )
    }

    init(
        initialStates: Set<State>,
        nextStates: @escaping (State) -> NextStateSequence,
        isFinalState: @escaping (State) -> Bool,
        historyTransform: @escaping (State) -> HistoryEntry
    ) {
        self.initialStates = initialStates
        self.nextStates = nextStates
        self.isFinalState = isFinalState
        self.historyTransform = historyTransform

        currentStates = initialStates

        history = initialStates.reduce(into: Set<HistoryEntry>()) {
            $0.insert(historyTransform($1))
        }
    }

    mutating func minimumIterationCount() -> Int? {
        while let nextIteration = next() {
            if nextIteration.contains(where: isFinalState) {
                return iterations
            }
        }

        return nil
    }

    mutating func minimumIterations() -> Set<State>? {
        while let nextIteration = next() {
            let finalStates = nextIteration.filter(isFinalState)

            if finalStates.isNotEmpty {
                return finalStates
            }
        }

        return nil
    }

}

extension BreadthFirstSearch: IteratorProtocol {

    mutating func next() -> Set<State>? {
        iterations += 1
        log("BFS<\(State.self)> Iteration \(iterations)")

        var nextStates: Set<State> = []

        for state in currentStates.flatMap(self.nextStates) {
            let historyEntry = historyTransform(state)
            log("Checking history for \(HistoryEntry.self): \(historyEntry)")

            if history.contains(historyEntry) {
                log("Found in history, discarding")
            }
            else {
                log("Not found, adding to next states")
                nextStates.insert(state)
                history.insert(historyEntry)
            }
        }

        currentStates = nextStates

        return nextStates.isEmpty ? nil : nextStates
    }

}
