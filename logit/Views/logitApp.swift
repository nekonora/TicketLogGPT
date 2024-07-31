//
//  logitApp.swift
//  logit
//
//  Created by Filippo Zaffoni on 06/06/24.
//

import SwiftUI

@main
struct logitApp: App {
    
    @StateObject private var openAIHandler = OpenAIHandler()
    @StateObject private var commandLineHandler = CommandLineHandler()
    @StateObject private var dateHandler = DateHandler()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(openAIHandler)
                .environmentObject(commandLineHandler)
                .environmentObject(dateHandler)
        }
        Settings {
            SettingsView()
                .environmentObject(openAIHandler)
                .environmentObject(commandLineHandler)
        }
    }
}
