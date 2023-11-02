//
//  SettingsView-ReposFetcher.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 01/11/2023.
//

import SwiftUI

extension SettingsView {
	@MainActor class SettingsViewModel: ObservableObject {
		@Published private(set) var repositories: [String] = []
		@Published var showAlert = false
		
		func performURLRequest() async {
			let tempData = await ReposFetcher.getRepositories(for: UserSettings().username) {
				print($0.localizedDescription)
				showAlert = true
			}
			
			Task { @MainActor in
				withAnimation {
					repositories = tempData
				}
			}
		}
	}
}
