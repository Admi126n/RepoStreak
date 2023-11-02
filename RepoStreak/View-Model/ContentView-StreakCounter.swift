//
//  ContentView-StreakCounter.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 01/11/2023.
//

import Foundation

extension ContentView {
	@MainActor class ContentViewModel: ObservableObject {
		@Published private(set) var repositoriesData = RepositoriesData()
		@Published private(set) var userSettings = UserSettings()
		
		@Published private(set) var alertMessage = ""
		@Published var showAlert = false
		@Published var showSheet = false
		
		func performURLRequest() async {
			repositoriesData = await StreakCounter.checkStreakForReposList(
				user: userSettings.username,
				mainRepo: userSettings.mainRepository
			) {
				print($0.localizedDescription)
				alertMessage = "Something went wrong."
				showAlert = true
			}
		}
	}
}
