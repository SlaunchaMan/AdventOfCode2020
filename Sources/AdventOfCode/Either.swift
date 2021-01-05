//
//  Either.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 1/4/21.
//

import Foundation

enum Either<T, U> {

    case first(T)
    case second(U)

    var first: T? {
        if case .first(let value) = self {
            return value
        }

        return nil
    }

    var second: U? {
        if case .second(let value) = self {
            return value
        }

        return nil
    }

}
