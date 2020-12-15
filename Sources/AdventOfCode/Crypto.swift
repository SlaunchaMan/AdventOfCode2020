//
//  Crypto.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/14/20.
//

import CryptoKit
import Foundation

extension Insecure.MD5.Digest {

    var stringValue: String {
        map { String(format: "%02hhx", $0) }.joined()
    }

}
