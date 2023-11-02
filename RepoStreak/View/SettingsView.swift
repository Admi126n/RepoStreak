//
//  SettingsView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 30/09/2023.
//

import SwiftUI

struct SettingsView: View {
    private let alertTitle = "Something went wrong"
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var repoData: UserSettings
    
    @State private var repositories: [String] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                    .onSubmit {
                        Task { await performURLRequest() }
                    }
                }
                
                Picker(selection: $repoData.mainRepository) {
                    ForEach(repositories, id: \.self) {
                        Text($0)
                    }
                } label: {
                    Text("Main repository")
                }
                .pickerStyle(.inline)
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Settings")
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .task {
            await performURLRequest()
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func performURLRequest() async {
        repositories = await ReposFetcher.getRepositories(for: repoData.username) {
			print($0.localizedDescription)
		}
    }
}

#Preview {
    SettingsView(repoData: UserSettings())
}
