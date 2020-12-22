//
//  ConcurrentDictionary.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/19/20.
//

import Foundation

class ConcurrentDictionary<Key, Value> where Key: Hashable {

    typealias DictionaryType = [Key: Value]
    typealias Element = DictionaryType.Element

    private let queue = DispatchQueue(
        label: "ConcurrentDictionary<\(Key.self), \(Value.self)>",
        attributes: [.concurrent]
    )

    private var storage: DictionaryType

    private init(storage: DictionaryType) {
        self.storage = storage
    }

    func perform<T>(
        _ operation: (inout DictionaryType) throws -> T
    ) rethrows -> T {
        try queue.sync(flags: .barrier) {
            try operation(&storage)
        }
    }

    // MARK: - Creating a Dictionary

    init() {
        storage = DictionaryType()
    }

    init(minimumCapacity: Int) {
        storage = DictionaryType(minimumCapacity: minimumCapacity)
    }

    init<S>(
        uniqueKeysWithValues keysAndValues: S
    ) where S: Sequence, S.Element == (Key, Value) {
        storage = DictionaryType(uniqueKeysWithValues: keysAndValues)
    }

    init<S>(
        _ keysAndValues: S,
        uniquingKeysWith combine: (Value, Value) throws -> Value
    ) rethrows where S: Sequence, S.Element == (Key, Value) {
        storage = try DictionaryType(keysAndValues, uniquingKeysWith: combine)
    }

    init<S>(
        grouping values: S,
        by keyForValue: (S.Element) throws -> Key
    ) rethrows where Value == [S.Element], S: Sequence {
        storage = try DictionaryType(grouping: values, by: keyForValue)
    }

    // MARK: - Accessing Keys and Values

    subscript(key: Key) -> Value? {
        get {
            queue.sync { storage[key] }
        }
        set {
            queue.sync(flags: .barrier) { storage[key] = newValue }
        }
    }

    subscript(
        key: Key,
        default defaultValue: @autoclosure () -> Value
    ) -> Value {
        get {
            queue.sync { storage[key, default: defaultValue()]}
        }
        set {
            queue.sync(flags: .barrier) {
                storage[key, default: defaultValue()] = newValue
            }
        }
    }

    func randomElement() -> (key: Key, value: Value)? {
        queue.sync { storage.randomElement() }
    }

    func randomElement<T>(
        using generator: inout T
    ) -> (key: Key, value: Value)? where T: RandomNumberGenerator {
        queue.sync { storage.randomElement(using: &generator) }
    }

    // MARK: - Adding Keys and Values

    @discardableResult
    func updateValue(_ value: Value, forKey key: Key) -> Value? {
        queue.sync(flags: .barrier) {
            storage.updateValue(value, forKey: key)
        }
    }

    func merge(
        _ other: DictionaryType,
        uniquingKeysWith combine: (Value, Value) throws -> Value
    ) rethrows {
        try queue.sync(flags: .barrier) {
            try storage.merge(other, uniquingKeysWith: combine)
        }
    }

    func merging(
        _ other: DictionaryType,
        uniquingKeysWith combine: (Value, Value) throws -> Value
    ) rethrows -> ConcurrentDictionary<Key, Value> {
        try ConcurrentDictionary(storage: queue.sync {
            try storage.merging(other, uniquingKeysWith: combine)
        })
    }

    func reserveCapacity(_ minimumCapacity: Int) {
        queue.sync(flags: .barrier) {
            storage.reserveCapacity(minimumCapacity)
        }
    }

    // MARK: - Removing Keys and Values

    func filter(
        _ isIncluded: (Element) throws -> Bool
    ) rethrows -> ConcurrentDictionary<Key, Value> {
        try ConcurrentDictionary(storage: queue.sync {
            try storage.filter(isIncluded)
        })
    }

    @discardableResult
    func removeValue(forKey key: Key) -> Value? {
        queue.sync(flags: .barrier) {
            storage.removeValue(forKey: key)
        }
    }

    func removeAll(keepingCapacity keepCapacity: Bool = false) {
        queue.sync(flags: .barrier) {
            storage.removeAll(keepingCapacity: keepCapacity)
        }
    }

}
