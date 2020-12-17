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

enum ExampleOption: String, EnumerableFlag {
    case one = "1"
    case two = "2"

    static func name(for value: ExampleOption) -> NameSpecification {
        switch value {
        case .one: return .customLong("with-example-1")
        case .two: return .customLong("with-example-2")
        }
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

        @Flag
        var examples: [ExampleOption] = []

        static let fileDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/d/yy"
            return formatter
        }()

        var byline: String {
            "Created by \(userName) on \(formattedDate)."
        }

        var formattedDate: String {
            Self.fileDateFormatter.string(from: Date())
        }

        var swiftFileContents: String {
            func example(_ n: Int) -> String {
                """

                        public static func example\(n)() -> String {
                            ""
                        }

                """
            }

            return """
            //
            //  \(year)Day\(day).swift
            //  AdventOfCode
            //
            //  \(byline)
            //

            import Foundation

            extension Year\(year) {

                public enum Day\(day): Puzzle {

                    public static let year: Year.Type = Year\(year).self

                    public static let day = \(day)
            \(examples.contains(.one) ? example(1) : "")
                    public static func part1() -> String {
                        ""
                    }
            \(examples.contains(.two) ? example(2) : "")
                    public static func part2() -> String {
                        ""
                    }

                }

            }

            """
        }

        var testFileContents: String {
            func testExample(_ n: Int) -> String {
                """

                    func testExample\(n)() {
                        XCTAssertEqual(Year\(year).Day\(day).example\(n)(), "")
                    }

                """
            }

            return """
            //
            //  \(year)Day\(day)Tests.swift
            //  AdventOfCodeTests
            //
            //  \(byline)
            //

            import AdventOfCode
            import XCTest

            class Year\(year)Day\(day)Tests: XCTestCase {
            \(examples.contains(.one) ? testExample(1) : "")
                func testPart1() {
                    XCTAssertEqual(Year\(year).Day\(day).part1(), "")
                }
            \(examples.contains(.two) ? testExample(2) : "")
                func testPart2() {
                    XCTAssertEqual(Year\(year).Day\(day).part2(), "")
                }

            }

            """
        }

        var userName: String {
            ProcessInfo.processInfo.fullUserName
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

        // swiftlint:disable:next function_body_length
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
