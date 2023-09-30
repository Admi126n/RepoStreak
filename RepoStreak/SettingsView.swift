//
//  SettingsView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 30/09/2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var repoData: RepositoryData
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Username") {
                    TextField("Username", text: Binding(
                        get: {
                            repoData.username
                        }, set: {
                            repoData.username = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    ))
                }
                
                Section("Repository name") {
                    TextField("Repository name", text: Binding(
                        get: {
                            repoData.repositoryName
                        }, set: {
                            repoData.repositoryName = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    ))
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Settings")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    SettingsView(repoData: RepositoryData())
}
