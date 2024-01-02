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
					.disabled(settingsViewModel.gettingData)
                }
                
				Picker(selection: $userSettings.fetchingType) {
					ForEach(FetchingType.allCases, id: \.self) {
						Text($0.description)
					}
				} label: {
					Text("How to fetch commits?")
				}
				.pickerStyle(.inline)
				
				Picker(selection: $userSettings.mainRepository) {
					if settingsViewModel.gettingData {
						ProgressView()
					}
					
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
		.tint(.orange)
        .task { await settingsViewModel.performURLRequest() }
		.alert("Something went wrong.", isPresented: $settingsViewModel.showAlert) { }
    }
}

#Preview {
	SettingsView(userSettings: UserSettings()) { }
}
