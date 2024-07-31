//
//  CommandLineHandler.swift
//  logit
//
//  Created by Filippo Zaffoni on 06/06/24.
//

import Foundation

final class CommandLineHandler: ObservableObject {
    
    func getGitLog() -> String? {
        guard let directory = loadBookmarkFromData(), let username = AppPreferences.username else { return nil }
        let process = Process()
        let pipe = Pipe()

        process.executableURL = URL(fileURLWithPath: "/bin/zsh")
        process.arguments = ["-c", "git log --author=\"\(username)\" --all --pretty=format:\"%cs; %d\" --date-order --after=\"\(getDateForLastNDays(40))\""]
        process.standardOutput = pipe
        process.standardError = pipe
        process.currentDirectoryURL = directory

        do {
            try process.run()
        } catch {
            print("Error running command: \(error.localizedDescription)")
            return nil
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let result = String(data: data, encoding: .utf8)?
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: "HEAD -> ", with: "")
            .replacingOccurrences(of: "origin/", with: "")
            .replacingOccurrences(of: "feature/", with: "")
            .components(separatedBy: .newlines)
                .filter { line in
                    let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                    return !trimmedLine.isEmpty && !trimmedLine.matches("^\\d{4}-\\d{2}-\\d{2};?$")
                }
                .joined(separator: "\n")
        print(result ?? "No output")
        return result
    }
    
    func loadBookmarkFromData() -> URL? {
        guard let bookmarkData = AppPreferences.selectedFolder else { return nil }
        var isStale = false
        do {
            let url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
            if isStale {
                print("Bookmark data is stale")
            }
            return url
        } catch {
            print("Failed to load bookmark: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func getDateForLastNDays(_ days: Int) -> String {
        let calendar = Calendar.current
        if let date = calendar.date(byAdding: .day, value: -days, to: Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
        return ""
    }
}
