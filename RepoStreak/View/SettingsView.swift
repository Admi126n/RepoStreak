//
//  SettingsView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 30/09/2023.
//

import SwiftUI

struct SettingsView: View {
	@Environment(\.dismiss) var dismiss
	@ObservedObject var userSettings: UserSettings
	@StateObject var settingsViewModel = SettingsViewModel()
	
	private let alertTitle = "Something went wrong."
	let onSave: () -> ()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Username") {
                    TextField("Username", text: Binding(
                        get: {
							userSettings.username
                        }, set: {
							userSettings.username = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    ))
                    .onSubmit {
						Task {
							await settingsViewModel.performURLRequest()
						}
                    }
                }
                
				Picker(selection: $userSettings.mainRepository) {
					ForEach(settingsViewModel.repositories, id: \.self) {
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
                Button("Save") {
					onSave()
					dismiss()
                }
            }
        }
        .task { await settingsViewModel.performURLRequest() }
		.alert(alertTitle, isPresented: $settingsViewModel.showAlert) { }
    }
}

#Preview {
	SettingsView(userSettings: UserSettings()) { }
}
