//
//  StringDecoder.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/7/20.
//

import Foundation

extension String {

    var totalRange: NSRange {
        NSRange(location: 0, length: utf16.count)
    }

}

enum StringDecoderError: Error {
    case notFound
    case couldNotConvertType
}

final class StringDecoder {

    let formatString: String

    init(formatString: String) {
        self.formatString = formatString
    }

    func decode<T>(
        _ type: T.Type,
        from input: String
    ) throws -> T where T: Decodable {
        let decoder = InnerStringDecoder(formatString: formatString,
                                         input: input)

        return try type.init(from: decoder)
    }

}

private final class InnerStringDecoder: Decoder {

    struct KDC<Key: CodingKey>: KeyedDecodingContainerProtocol {

        let formatString: String
        let input: String

        func regularExpression() throws -> NSRegularExpression {
            let pattern = #"\$\((?<key>\w+)\)"#
            let regex = try NSRegularExpression(pattern: pattern,
                                                options: [])

            let newPattern = regex.stringByReplacingMatches(
                in: formatString,
                options: [],
                range: formatString.totalRange,
                withTemplate: #"(?<$1>\\S+)"#
            )

            return try NSRegularExpression(pattern: newPattern, options: [])
        }

        func contains(_ key: Key) -> Bool {
            do {
                _ = try decode(String.self, forKey: key)
                return true
            }
            catch {
                return false
            }
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            fatalError()
        }

        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            fatalError()
        }

        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            let regex = try regularExpression()

            guard let match = regex.firstMatch(in: input,
                                               options: [],
                                               range: input.totalRange)
            else { throw StringDecoderError.notFound }

            let range = match.range(withName: key.stringValue)

            guard range.location != NSNotFound else {
                throw StringDecoderError.notFound
            }

            return (input as NSString).substring(with: range)
        }

        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            let stringValue = try decode(String.self, forKey: key)

            guard let value = Double(stringValue) else {
                throw StringDecoderError.couldNotConvertType
            }

            return value
        }

        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            let stringValue = try decode(String.self, forKey: key)

            guard let value = Float(stringValue) else {
                throw StringDecoderError.couldNotConvertType
            }

            return value
        }

        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            let stringValue = try decode(String.self, forKey: key)

            guard let value = Int(stringValue) else {
                throw StringDecoderError.couldNotConvertType
            }

            return value
        }

        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            let stringValue = try decode(String.self, forKey: key)

            guard let value = Int8(stringValue) else {
                throw StringDecoderError.couldNotConvertType
            }

            return value
        }

        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            let stringValue = try decode(String.self, forKey: key)

            guard let value = Int16(stringValue) else {
                throw StringDecoderError.couldNotConvertType
            }

            return value
        }

        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            let stringValue = try decode(String.self, forKey: key)

            guard let value = Int32(stringValue) else {
                throw StringDecoderError.couldNotConvertType
            }

            return value
        }

        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            let stringValue = try decode(String.self, forKey: key)

            guard let value = Int64(stringValue) else {
                throw StringDecoderError.couldNotConvertType
            }

            return value
        }

        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            let stringValue = try decode(String.self, forKey: key)

            guard let value = UInt(stringValue) else {
                throw StringDecoderError.couldNotConvertType
            }

            return value
        }

        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            let stringValue = try decode(String.self, forKey: key)

            guard let value = UInt8(stringValue) else {
                throw StringDecoderError.couldNotConvertType
            }

            return value
        }

        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            let stringValue = try decode(String.self, forKey: key)

            guard let value = UInt16(stringValue) else {
                throw StringDecoderError.couldNotConvertType
            }

            return value
        }

        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            let stringValue = try decode(String.self, forKey: key)

            guard let value = UInt32(stringValue) else {
                throw StringDecoderError.couldNotConvertType
            }

            return value
        }

        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            let stringValue = try decode(String.self, forKey: key)

            guard let value = UInt64(stringValue) else {
                throw StringDecoderError.couldNotConvertType
            }

            return value
        }

        func decode<T>(
            _ type: T.Type,
            forKey key: Key
        ) throws -> T where T: Decodable {
            fatalError()
        }

        func nestedContainer<NestedKey>(
            keyedBy type: NestedKey.Type,
            forKey key: Key
        ) throws -> KeyedDecodingContainer<NestedKey>
        where NestedKey: CodingKey {
            fatalError()
        }

        func nestedUnkeyedContainer(
            forKey key: Key
        ) throws -> UnkeyedDecodingContainer {
            fatalError()
        }

        func superDecoder() throws -> Decoder {
            fatalError()
        }

        func superDecoder(forKey key: Key) throws -> Decoder {
            fatalError()
        }

        var codingPath: [CodingKey] = []
        var allKeys: [Key] = []

    }

    let formatString: String
    let input: String

    init(formatString: String, input: String) {
        self.formatString = formatString
        self.input = input
    }

    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]

    func container<Key>(
        keyedBy type: Key.Type
    ) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        KeyedDecodingContainer(KDC(formatString: formatString, input: input))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }

}
