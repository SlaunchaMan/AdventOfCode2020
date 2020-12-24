//
//  CollectionRotation.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/23/20.
//

import Foundation

extension RangeReplaceableCollection {

    mutating func rotateLeft(_ offset: Int = 1) {
        for _ in 0 ..< offset {
            append(removeFirst())
        }
    }

}

extension RangeReplaceableCollection where Self: BidirectionalCollection {

    mutating func rotateRight(_ offset: Int = 1) {
        for _ in 0 ..< offset {
            insert(removeLast(), at: startIndex)
        }
    }

}
