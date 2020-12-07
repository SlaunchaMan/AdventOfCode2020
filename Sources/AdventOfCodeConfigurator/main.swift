//
//  main.swift
//  AdventOfCodeConfigurator
//
//  Created by Jeff Kelley on 12/4/20.
//

import ArgumentParser
import Foundation

struct AdventOfCodeConfigurator: ParsableCommand {

    static var configuration = CommandConfiguration(
        subcommands: [AddDay.self]
    )

    struct AddDay: ParsableCommand {

        @Option(name: .shortAndLong)
        var year: Int

        @Option(name: .shortAndLong)
        var day: Int

        static let fileDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/d/yy"
            return formatter
        }()

        var formattedDate: String {
            Self.fileDateFormatter.string(from: Date())
        }

        var swiftFileContents: String {
            """
            //
            //  \(year)Day\(day).swift
            //  AdventOfCode
            //
            //  Created by \(ProcessInfo().fullUserName) on \(formattedDate).
            //

            import Foundation

            extension Year\(year) {

                public enum Day\(day): Puzzle {

                    public static let year: Year.Type = Year\(year).self

                    public static let day = \(day)

                    public static func part1() -> String {
                        ""
                    }

                    public static func part2() -> String {
                        ""
                    }

                }

            }
            """
        }

        var testFileContents: String {
            """
            //
            //  \(year)Day\(day)Tests.swift
            //  AdventOfCodeTests
            //
            //  Created by \(ProcessInfo().fullUserName) on \(formattedDate).
            //

            import AdventOfCode
            import XCTest

            class Year\(year)Day\(day)Tests: XCTestCase {

                func testPart1() {
                    XCTAssertEqual(Year\(year).Day\(day).part1(), "")
                }

                func testPart2() {
                    XCTAssertEqual(Year\(year).Day\(day).part2(), "")
                }

            }
            """
        }

        mutating func run() throws {
            let fileManager = FileManager()

            let sourcesPath = fileManager.currentDirectoryPath + "/Sources"
            let testsPath = fileManager.currentDirectoryPath + "/Tests"

            let frameworkPath = "\(sourcesPath)/AdventOfCode"
            let resourcesPath = "\(frameworkPath)/Resources"
            let testPath = "\(testsPath)/AdventOfCodeTests"

            let sourcePath = "\(frameworkPath)/\(year)/\(year)Day\(day).swift"
            let inputPath = "\(resourcesPath)/inputs/\(year)/Day\(day).txt"
            let testFilePath = "\(testPath)/\(year)/\(year)Day\(day)Tests.swift"

            try swiftFileContents.write(toFile: sourcePath,
                                        atomically: true,
                                        encoding: .utf8)

            try testFileContents.write(toFile: testFilePath,
                                       atomically: true,
                                       encoding: .utf8)

            if CommandLine.arguments.last == "--" {
                var input: String = ""

                while let line = readLine() {
                    if !input.isEmpty {
                        input.append("\n")
                    }

                    input.append(line)
                }

                try input.write(toFile: inputPath,
                                atomically: true,
                                encoding: .utf8)
            }
            else {
                fileManager.createFile(atPath: inputPath,
                                       contents: nil,
                                       attributes: nil)
            }
        }

    }

}

AdventOfCodeConfigurator.main()
