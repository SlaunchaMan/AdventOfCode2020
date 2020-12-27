//
//  main.swift
//  AdventOfCodeConfigurator
//
//  Created by Jeff Kelley on 12/4/20.
//

import ArgumentParser
import Foundation
import IsNotEmpty

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

            func part(_ n: Int) -> String {
                """

                        public static func part\(n)() -> String {
                            ""
                        }

                """
            }

            let protocolName: String

            switch (examples.contains(.one), examples.contains(.two)) {
            case (false, false) where day == 25: protocolName = "Puzzle"
            case (true, true): protocolName = "FullPuzzle"
            case (true, false) where day == 25:
                protocolName = "PuzzleWithExample1"
            case (true, false): protocolName = "TwoPartPuzzleWithExample1"
            case (false, true): protocolName = "PuzzleWithExample2"
            default: protocolName = "TwoPartPuzzle"
            }

            var file = """
            //
            //  \(year)Day\(day).swift
            //  AdventOfCode
            //
            //  \(byline)
            //

            import Foundation

            extension Year\(year) {

                public enum Day\(day): \(protocolName) {

                    public static let year: Year.Type = Year\(year).self

                    public static let day = \(day)

            """

            if examples.contains(.one) {
                file.append(example(1))
            }

            file.append(part(1))

            if examples.contains(.two) {
                file.append(example(2))
            }

            if examples.contains(.two) || day != 25 {
                file.append(part(2))
            }

            file.append(
                """

                    }

                }
                """
            )

            return file
        }

        var testFileContents: String {
            func testExample(_ n: Int) -> String {
                """

                    func testExample\(n)() {
                        XCTAssertEqual(Year\(year).Day\(day).example\(n)(), "")
                    }

                """
            }

            func testPart(_ n: Int) -> String {
                """

                    func testPart\(n)() {
                        XCTAssertEqual(Year\(year).Day\(day).part\(n)(), "")
                    }

                """
            }

            var file = """
            //
            //  \(year)Day\(day)Tests.swift
            //  AdventOfCodeTests
            //
            //  \(byline)
            //

            import AdventOfCode
            import XCTest

            class Year\(year)Day\(day)Tests: XCTestCase {

            """

            if examples.contains(.one) {
                file.append(testExample(1))
            }

            file.append(testPart(1))

            if examples.contains(.two) {
                file.append(testExample(2))
            }

            if examples.contains(.two) || day != 25 {
                file.append(testPart(2))
            }

            file.append("""

                }

                """
            )

            return file
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
                    if input.isNotEmpty {
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
