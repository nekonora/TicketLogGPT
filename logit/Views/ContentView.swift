//
//  ContentView.swift
//  logit
//
//  Created by Filippo Zaffoni on 06/06/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var openAIHandler: OpenAIHandler
    @EnvironmentObject var commandLineHandler: CommandLineHandler
    @EnvironmentObject var dateHandler: DateHandler
    
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Button(action: {
                    onGenerateLog()
                }) {
                    Text("Get Git log")
                }
                .disabled((AppPreferences.username?.isEmpty ?? true) || (commandLineHandler.loadBookmarkFromData() == nil))
                
                if isLoading {
                    ProgressView()
                }
                
                Spacer()
            }
            
            Spacer()
        }
    }
    
    private func onGenerateLog() {
        let commandOutput = commandLineHandler.getGitLog()
        Task {
            do {
                let gptEntries = try await openAIHandler.parseLogWithGPT(commandOutput)
                let calendar = Calendar.current
                print("\n\n")
                
                let filledEntries = dateHandler.fillInMissingDates(from: gptEntries)
                
                for entry in filledEntries {
                    let date = calendar.date(byAdding: .day, value: 1, to: entry.day)
                    print((date ?? entry.day).formatted())
                    print(entry.tickets.map(\.description).joined(separator: "; "))
                    print("")
                    print(entry.tickets.map(\.url).joined(separator: "; "))
                    print("\n\n")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ContentView()
}
