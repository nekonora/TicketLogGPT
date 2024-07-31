//
//  SettingsView.swift
//  logit
//
//  Created by Filippo Zaffoni on 06/06/24.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var commandLineHandler: CommandLineHandler
    
    @State private var usernameTextfieldText: String = ""
    @State private var openAIAPIKeyTextfieldText: String = ""
    @State private var repoURLTextFieldText: String = ""
    
    private let rowHeight: CGFloat = 40
    
    var body: some View {
        List {
            HStack {
                Button(action: {
                    selectFolder()
                }) {
                    Text("Select Folder")
                }
                .frame(width: 150)
                
                if let folderPath = commandLineHandler.loadBookmarkFromData() {
                    Text(folderPath.path(percentEncoded: true))
                } else {
                    Text("Missing folder")
                }
                
                Spacer()
                
                Image(systemName: commandLineHandler.loadBookmarkFromData() == nil ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 18))
                    .padding()
            }
            .frame(height: rowHeight)
            
            HStack {
                Button(action: {
                    AppPreferences.username = usernameTextfieldText
                    onSettingsUpdated()
                }) {
                    Text("Set author username")
                }
                .frame(width: 150)
                
                TextField(AppPreferences.username ?? "Author username", text: $usernameTextfieldText)
                    .textFieldStyle(.roundedBorder)
                
                Spacer()
                
                Image(systemName: AppPreferences.username == nil ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 18))
                    .padding()
            }
            .frame(height: rowHeight)
            
            HStack {
                Button(action: {
                    AppSecureKeys.openAIAPIKey = openAIAPIKeyTextfieldText
                    onSettingsUpdated()
                }) {
                    Text("Set OpenAI API Key")
                }
                .frame(width: 150)
                
                SecureField("OpenAI API Key", text: $openAIAPIKeyTextfieldText)
                    .textFieldStyle(.roundedBorder)
                
                Spacer()
                
                Image(systemName: AppSecureKeys.openAIAPIKey == nil ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 18))
                    .padding()
            }
            .frame(height: rowHeight)
            
            HStack {
                Button(action: {
                    AppPreferences.repoUrl = repoURLTextFieldText
                    onSettingsUpdated()
                }) {
                    Text("Set url of the repo")
                }
                .frame(width: 150)
                
                TextField(AppPreferences.repoUrl ?? "Repo url", text: $repoURLTextFieldText)
                    .textFieldStyle(.roundedBorder)
                
                Spacer()
                
                Image(systemName: AppPreferences.repoUrl == nil ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 18))
                    .padding()
            }
            .frame(height: rowHeight)

            
            Spacer()
        }
        .listStyle(.sidebar)
        .frame(minWidth: 600, minHeight: 200)
        .onAppear {
            onSettingsUpdated()
        }
    }
    
    private func onSettingsUpdated() {
        if let username = AppPreferences.username { usernameTextfieldText = username }
        if let apiKey = AppSecureKeys.openAIAPIKey { openAIAPIKeyTextfieldText = apiKey }
    }
    
    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK,
            let url = panel.urls.first,
            let bookmarkData = try? url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil) {
            AppPreferences.selectedFolder = bookmarkData
            onSettingsUpdated()
        }
    }
}
