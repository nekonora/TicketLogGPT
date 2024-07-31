//
//  GeneratedLogEntry.swift
//  logit
//
//  Created by Filippo Zaffoni on 06/06/24.
//

import Foundation

struct GeneratedEntriesList: Codable {
    let days: [GeneratedLogEntry]
}

struct GeneratedLogEntry: Codable, Equatable {
    let day: Date
    let tickets: [GeneratedTicketsEntry]
    
    var exportString: String {
        "\(tickets)\n\n"
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.day == rhs.day
    }
}

struct GeneratedTicketsEntry: Codable, Equatable {
    let ticket: Int
    let description: String

    var url: String {
        "\(AppPreferences.repoUrl ?? "")\(ticket)"
    }
}
