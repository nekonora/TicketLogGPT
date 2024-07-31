//
//  DateHandler.swift
//  logit
//
//  Created by Filippo Zaffoni on 06/06/24.
//

import Foundation

final class DateHandler: ObservableObject {
    
    func fillInMissingDates(from entries: [GeneratedLogEntry]) -> [GeneratedLogEntry] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var lastIssues: [GeneratedTicketsEntry] = []
        let dates = entries.map(\.day)
        var allDates = Set(dates)
        
        guard let startDate = dates.min(), let endDate = dates.max() else {
            fatalError("Unable to determine date range")
        }
        
        let calendar = Calendar.current
        
        var currentDate = startDate
        while currentDate <= endDate {
            if isWorkday(currentDate) && !allDates.contains(currentDate) {
                allDates.insert(currentDate)
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        var allEntries = [GeneratedLogEntry]()
        for date in Array(allDates).sorted(by: >) {
            if let entry = entries.first(where: { $0.day == date }) {
                lastIssues = entry.tickets
                allEntries.append(entry)
            } else {
                allEntries.append(GeneratedLogEntry(day: date, tickets: lastIssues))
            }
        }
        
        return allEntries
    }
    
    private func isWorkday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        return weekday != 1 && weekday != 7
    }
}
