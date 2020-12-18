//
//  2016Day10.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/17/20.
//

import Foundation
import StringDecoder

private let exampleInput =
    """
    value 5 goes to bot 2
    bot 2 gives low to bot 1 and high to bot 0
    value 3 goes to bot 1
    bot 1 gives low to output 1 and high to bot 0
    bot 0 gives low to output 2 and high to output 0
    value 2 goes to bot 2
    """

extension KeyedDecodingContainer {
    
    func contains(_ keys: [Key]) -> Bool {
        keys.allSatisfy(contains)
    }
    
}

extension Year2016 {

    public enum Day10: PuzzleWithExample1 {

        public static let year: Year.Type = Year2016.self

        public static let day = 10
        
        enum Instruction: Decodable {
            case value(value: Int, botID: Int)
            case botToBots(botID: Int, lowBotID: Int, highBotID: Int)
            case botToOutputAndBot(botID: Int, lowOutputID: Int, highBotID: Int)
            case botToBotAndOutput(botID: Int, lowBotID: Int, highOutputID: Int)
            case botToOutputs(botID: Int, lowOutputID: Int, highOutputID: Int)
            
            enum CodingKeys: String, CodingKey {
                case value
                case botID = "id"
                case lowBotID
                case lowOutputID
                case highBotID
                case highOutputID
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                if container.contains(.value) {
                    self = .value(
                        value: try container.decode(Int.self, forKey: .value),
                        botID: try container.decode(Int.self, forKey: .botID)
                    )
                }
                else if container.contains([.lowBotID, .highBotID]) {
                    self = .botToBots(
                        botID: try container.decode(Int.self, forKey: .botID),
                        lowBotID: try container.decode(Int.self,
                                                       forKey: .lowBotID),
                        highBotID: try container.decode(Int.self,
                                                        forKey: .highBotID)
                    )
                }
                else if container.contains([.lowBotID, .highOutputID]) {
                    self = .botToBotAndOutput(
                        botID: try container.decode(Int.self, forKey: .botID),
                        lowBotID: try container.decode(Int.self,
                                                       forKey: .lowBotID),
                        highOutputID: try container.decode(
                            Int.self,
                            forKey: .highOutputID
                        )
                    )
                }
                else if container.contains([.lowOutputID, .highBotID]) {
                    self = .botToOutputAndBot(
                        botID: try container.decode(Int.self, forKey: .botID),
                        lowOutputID: try container.decode(Int.self,
                                                          forKey: .lowOutputID),
                        highBotID: try container.decode(Int.self,
                                                        forKey: .highBotID)
                    )
                }
                else if container.contains([.lowOutputID, .highOutputID]) {
                    self = .botToOutputs(
                        botID: try container.decode(
                            Int.self,
                            forKey: .botID
                        ),
                        lowOutputID: try container.decode(
                            Int.self,
                            forKey: .lowOutputID
                        ),
                        highOutputID: try container.decode(
                            Int.self,
                            forKey: .highOutputID
                        )
                    )
                }
                else {
                    throw DecodingError.dataCorrupted(
                        DecodingError.Context(
                            codingPath: container.codingPath,
                            debugDescription: "No valid formats found."
                        )
                    )
                }
            }
        }
        
        private static var instructionDecoder = StringDecoder(
            // swiftlint:disable line_length
            formatStrings: [
                "value $(value) goes to bot $(id)",
                "bot $(id) gives low to bot $(lowBotID) and high to bot $(highBotID)",
                "bot $(id) gives low to output $(lowOutputID) and high to bot $(highBotID)",
                "bot $(id) gives low to bot $(lowBotID) and high to output $(highOutputID)",
                "bot $(id) gives low to output $(lowOutputID) and high to output $(highOutputID)"
            ]
            // swiftlint:enable line_length
        )
        
        private static func process(
            instructions: [Instruction]
        ) -> (botContents: [Int: [Int]], output: [Int: Int]) {
            var instructions = instructions
            
            var botContents: [Int: [Int]] = [:]
            var outputContents: [Int: Int] = [:]
            
            func addValue(_ value: Int, toBot botID: Int) {
                botContents[botID] =
                    botContents[botID, default: []] + [value]
            }
            
            func addValue(_ value: Int, toOutput outputID: Int) {
                outputContents[outputID] = value
            }
            
            while !instructions.isEmpty {
                var pendingInstructions: [Instruction] = []
                
                for instruction in instructions {
                    switch instruction {
                    case let .value(value: value, botID: botID):
                        addValue(value, toBot: botID)
                        
                    case let .botToBots(botID: botID,
                                        lowBotID: lowID,
                                        highBotID: highID)
                            where botContents[botID]?.count == 2:
                        addValue(botContents[botID]!.min()!, toBot: lowID)
                        addValue(botContents[botID]!.max()!, toBot: highID)
                        
                    case let .botToBotAndOutput(botID: botID,
                                                lowBotID: lowID,
                                                highOutputID: highID)
                            where botContents[botID]?.count == 2:
                        addValue(botContents[botID]!.min()!, toBot: lowID)
                        addValue(botContents[botID]!.max()!, toOutput: highID)
                        
                    case let .botToOutputAndBot(botID: botID,
                                                lowOutputID: lowID,
                                                highBotID: highID)
                            where botContents[botID]?.count == 2:
                        addValue(botContents[botID]!.min()!, toOutput: lowID)
                        addValue(botContents[botID]!.max()!, toBot: highID)
                        
                    case let .botToOutputs(botID: botID,
                                           lowOutputID: lowID,
                                           highOutputID: highID)
                            where botContents[botID]?.count == 2:
                        addValue(botContents[botID]!.min()!, toOutput: lowID)
                        addValue(botContents[botID]!.max()!, toOutput: highID)

                    default:
                        pendingInstructions.append(instruction)                        
                    }
                    
                    instructions = pendingInstructions
                }
            }
            
            return (botContents, outputContents)
        }
        
        private static func bot(thatHandles chipA: Int,
                                _ chipB: Int,
                                using instructions: [Instruction]) -> Int {
            let (botContents, _) = process(instructions: instructions)

            if let winner = botContents.first(where: {
                $0.value.contains(chipA) && $0.value.contains(chipB)
            }) {
                return winner.key
            }
            
            fatalError()
        }
        
        private static func parseInstruction(_ line: String) -> Instruction? {
            do {
                return try instructionDecoder.decode(Instruction.self,
                                                     from: line)
            }
            catch {
                log(error)
                return nil
            }
        }
        
        public static func example1() -> String {
            let instructions: [Instruction] = parseInputLines(
                exampleInput,
                using: parseInstruction
            )
            
            return "\(bot(thatHandles: 5, 2, using: instructions))"
        }
        
        public static func part1() -> String {
            let instructions: [Instruction] = parseInputLines(
                puzzleInput(),
                using: parseInstruction
            )
            
            return "\(bot(thatHandles: 61, 17, using: instructions))"
        }

        public static func part2() -> String {
            let instructions: [Instruction] = parseInputLines(
                puzzleInput(),
                using: parseInstruction
            )
            
            let (_, output) = process(instructions: instructions)

            return "\(output[0]! * output[1]! * output[2]!)"
        }

    }

}
