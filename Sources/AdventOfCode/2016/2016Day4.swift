//
//  2016Day4.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/14/20.
//

import Foundation
import IsNotEmpty

private let exampleInput =
    """
    aaaaa-bbb-z-y-x-123[abxyz]
    a-b-c-d-e-f-g-h-987[abcde]
    not-a-real-room-404[oarel]
    totally-real-room-200[decoy]
    """

extension Year2016 {

    public enum Day4: Puzzle {

        public static let year: Year.Type = Year2016.self

        public static let day = 4

        struct Room {

            let encryptedName: String
            let sectorID: Int
            let checksum: String

            init?(string: String) {
                let components = string.components(
                    separatedBy: CharacterSet(charactersIn: "[]")
                ).filter(\.isNotEmpty)

                guard components.count == 2 else { return nil }

                var innerComponents = components[0].components(separatedBy: "-")
                guard let sectorID = Int(innerComponents.removeLast())
                else { return nil }

                encryptedName = innerComponents.joined(separator: "-")
                self.sectorID = sectorID
                checksum = components[1]
            }

            var isReal: Bool {
                checksum == String(
                    encryptedName
                        .filter { $0 != "-" }
                        .histogram()
                        .sorted {
                            $0.value == $1.value ?
                                $0.key > $1.key :
                                $0.value < $1.value
                        }
                        .reversed()
                        .prefix(5)
                        .map(\.key)
                )
            }

            func decrypt() -> String {
                encryptedName
                    .compactMap { $0 == "-" ? " " : $0.rotate(sectorID) }
                    .map(String.init)
                    .joined()
            }

        }

        public static func example1() -> String {
            let rooms = parseInputLines(exampleInput, using: Room.init)

            return "\(rooms.filter { $0.isReal }.sum(\.sectorID))"
        }

        public static func part1() -> String {
            let rooms = parseInputLines(puzzleInput(), using: Room.init)

            return "\(rooms.filter(\.isReal).sum(\.sectorID))"
        }

        public static func example2() -> String {
            Room(string: "qzmt-zixmtkozy-ivhz-343[zimth]")!.decrypt()
        }

        public static func part2() -> String {
            let rooms = parseInputLines(puzzleInput(), using: Room.init)

            let targetRoom = rooms
                .filter(\.isReal)
                .first { $0.decrypt() == "northpole object storage" }

            return "\(targetRoom!.sectorID)"
        }

    }

}
