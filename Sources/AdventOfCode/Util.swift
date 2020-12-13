//
//  Util.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/4/20.
//

import Foundation

private var isLoggingEnabled =
    (ProcessInfo().environment["ENABLE_LOGGING"] != nil) ?
    true : false

private var isCapturingLogs = false
private var capturedLog: String?

public func captureLogOutput(during workItem: () -> Void) -> String {
    isCapturingLogs = true
    capturedLog = ""
    workItem()
    isCapturingLogs = false

    let captured = capturedLog!
    capturedLog = nil

    return captured
}

public func setLoggingEnabled(_ enabled: Bool = true) {
    isLoggingEnabled = enabled
}

func log(_ message: @autoclosure() -> Any) {
    if isCapturingLogs {
        if !capturedLog!.isEmpty {
            capturedLog?.append("\n")
        }

        capturedLog?.append(String(describing: message()))
    }
    if isLoggingEnabled {
        print(message())
    }
}

extension Puzzle {

    static func parseInput(
        _ input: String,
        separatedBy separator: String
    ) -> [String] {
        input.components(separatedBy: separator)
    }

    static func parseInputLines(_ input: String) -> [String] {
        input.components(separatedBy: .newlines)
    }

    static func parseInputLines<T>(
        _ input: String,
        using transform: (String) throws -> T?
    ) rethrows -> [T] {
        try parseInputLines(input).compactMap(transform)
    }

    static func puzzleInput() -> String {
        let fileManager = FileManager()

        let resourcesPath = "Sources/AdventOfCode/Resources/"
        let inputDirectory = "inputs/\(year.year)"
        let spmPrefix = resourcesPath + inputDirectory

        guard let url = Bundle.module.url(forResource: "Day\(day)",
                                          withExtension: "txt",
                                          subdirectory: inputDirectory) else {
            fatalError(#"Couldn't find file at "\#(spmPrefix)/Day\#(day).txt""#)
        }

        guard let data = fileManager.contents(atPath: url.path) else {
            fatalError("Couldn't load data at URL \(url).")
        }

        guard let string = String(data: data, encoding: .utf8) else {
            fatalError("Couldn't turn file into text.")
        }

        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}
