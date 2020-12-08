//
//  main.swift
//  AdventOfCodeConfigurator
//
//  Created by Jeff Kelley on 12/4/20.
//

import ArgumentParser
import Foundation

extension String {

    func removingFirst(_ k: Int) -> String {
        var result = self
        result.removeFirst(k)
        return result
    }

    func removingLast(_ k: Int) -> String {
        var result = self
        result.removeLast(k)
        return result
    }

}

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

        func yearIndexContents(days: [Int]) -> String {
            let formattedDays = days.map {
                "        Year\(year).Day\($0).self"
            }.joined(separator: ",\n")

            return """
            //
            //  \(year).swift
            //  AdventOfCode
            //
            //  https://github.com/SlaunchaMan/AdventOfCode2020
            //

            import Foundation

            public enum Year\(year): Year {

                public static let year = \(year)

                public static var allPuzzles: [Puzzle.Type] = [
            \(formattedDays)
                ]

            }
            """
        }

        mutating func run() throws {
            let fileManager = FileManager()

            let sourcesPath = fileManager.currentDirectoryPath + "/Sources"
            let testsPath = fileManager.currentDirectoryPath + "/Tests"

            let frameworkPath = "\(sourcesPath)/AdventOfCode/\(year)"
            let rscPath = "\(sourcesPath)/AdventOfCode/Resources/inputs/\(year)"
            let testPath = "\(testsPath)/AdventOfCodeTests/\(year)"

            let sourcePath = "\(frameworkPath)/\(year)Day\(day).swift"
            let yearIndexPath = "\(frameworkPath)/\(year).swift"
            let inputPath = "\(rscPath)/Day\(day).txt"
            let testFilePath = "\(testPath)/\(year)Day\(day)Tests.swift"

            for folder in [frameworkPath, rscPath, testPath] {
                if !fileManager.fileExists(atPath: folder) {
                    try fileManager.createDirectory(
                        atPath: folder,
                        withIntermediateDirectories: true,
                        attributes: nil
                    )
                }
            }

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

            let allDays = try fileManager
                .contentsOfDirectory(atPath: rscPath)
                .map { $0.removingFirst(3) }
                .map { $0.removingLast(4) }
                .compactMap(Int.init)
                .sorted()

            try yearIndexContents(days: allDays).write(toFile: yearIndexPath,
                                                       atomically: true,
                                                       encoding: .utf8)
        }

    }

}

AdventOfCodeConfigurator.main()
