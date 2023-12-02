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
				Section(I18n.username) {
					TextField(I18n.username, text: Binding(
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
                
				Picker(selection: $userSettings.fetchingType) {
					ForEach(FetchingType.allCases, id: \.self) {
						Text($0.description)
					}
				} label: {
					Text(I18n.fetchingType)
				}
				.pickerStyle(.inline)
				
				Picker(selection: $userSettings.mainRepository) {
					ForEach(settingsViewModel.repositories, id: \.self) {
                        Text($0)
                    }
                } label: {
					Text(I18n.mainRepository)
                }
                .pickerStyle(.inline)
            }
            .preferredColorScheme(.dark)
			.navigationTitle(I18n.settings)
            .toolbar {
				Button(I18n.save) {
					onSave()
					dismiss()
                }
            }
        }
        .task { await settingsViewModel.performURLRequest() }
		.alert(I18n.alertTitle, isPresented: $settingsViewModel.showAlert) { }
    }
}

#Preview {
	SettingsView(userSettings: UserSettings()) { }
}
