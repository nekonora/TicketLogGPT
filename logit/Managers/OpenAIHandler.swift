//
//  OpenAIHandler.swift
//  logit
//
//  Created by Filippo Zaffoni on 06/06/24.
//

import Foundation
import OpenAI

enum GPTGenerationError: LocalizedError {
    case missingCommandLineOutput
    case failedFormatting(error: String?)
}

final class OpenAIHandler: ObservableObject {
    
    private let instance = OpenAI(apiToken: AppSecureKeys.openAIAPIKey ?? "")
    
    func parseLogWithGPT(_ output: String?) async throws -> [GeneratedLogEntry] {
        guard let output else { throw GPTGenerationError.missingCommandLineOutput }
        return try await getFormattedLogEntries(from: output)
    }
    
    private func getFormattedLogEntries(from log: String) async throws -> [GeneratedLogEntry] {
        var failureReason: String?
        let result = try await generateGPTAnswers(from: log)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let json = result.choices.first?.message.toolCalls?
            .map(\.function.arguments)
            .first {
            let data = Data(json.utf8)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(formatter)
            return try decoder.decode(GeneratedEntriesList.self, from: data).days
        } else {
            throw GPTGenerationError.failedFormatting(error: failureReason)
        }
    }
    
    private func generateGPTAnswers(from log: String) async throws -> ChatResult {
        let getIssuesLogFunction = ChatQuery.ChatCompletionToolParam(function: .init(
            name: "getWorkTicketsLog",
            description: "List the tickets I worked on for each day and add a human readable description for each one. Do not repeat days entries. If a day is repeated, merge all issues for that day into a single entry.",
            parameters: .init(
                type: .object,
                properties: [
                    "days": .init(type: .array, description: "List of work days with the tickets I worked on that day", items: .init(type: .object, properties: [
                        "day": .init(type: .string, description: "The relevant work day, formatted in yyyy-MM-dd. E.g.: '2024-03-32'"),
                        "tickets": .init(type: .array, description: "List of work tickets for a given day", items: .init(type: .object, properties: [
                            "ticket": .init(type: .integer, description: "The number identifier of the ticket, stripped of the '#' sign. E.g. from '#4232' to '4232'"),
                            "description": .init(type: .string, description: "A short human readable description of what I did for that specific ticket. E.g. 'Refactored network layer, fixed bugs'")
                        ]))
                    ]), uniqueItems: true),
                ]
            )
        ))
        let query = ChatQuery(
            messages: [
                ChatQuery.ChatCompletionMessageParam(role: .system, content: "You are a fellow software developer helping me write short work reports that I need to put into our time tracking service")!,
                ChatQuery.ChatCompletionMessageParam(role: .user, content: log)!
            ],
            model: .gpt4,
            tools: [getIssuesLogFunction]
        )
        return try await instance.chats(query: query)
    }
}
