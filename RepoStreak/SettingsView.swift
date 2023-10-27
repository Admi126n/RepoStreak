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
    
    @ObservedObject var repoData: RepositoryData
    
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
                
                Picker(selection: $repoData.repositoryName) {
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
        do {
            repositories = try await ReposFetcher.getRepositories(for: repoData.username)
        } catch ValidatorErrors.cannotCreateURLSession {
            alertMessage = "Cannot create URL session, check internet connection and your username"
            showAlert = true
        } catch ValidatorErrors.cannotDecodeData {
            alertMessage = "Cannot read fetched data"
            showAlert = true
        } catch ValidatorErrors.cannotCreateURL {
            alertMessage = "Cannot create URL, check your username"
            showAlert = true
        } catch {
            alertMessage = "Unknown error"
            showAlert = true
        }
        
    }
}

#Preview {
    SettingsView(repoData: RepositoryData())
}
