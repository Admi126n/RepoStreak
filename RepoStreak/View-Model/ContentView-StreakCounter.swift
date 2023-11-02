//
//  ContentView-StreakCounter.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 01/11/2023.
//

import SwiftUI

extension ContentView {
	@MainActor class ContentViewModel: ObservableObject {
		@Published private(set) var repositoriesData = RepositoriesData()
		@Published private(set) var userSettings = UserSettings()
		
		@Published var showAlert = false
		@Published var showSheet = false
		
		func performURLRequest() async {
			let tempData = await StreakCounter.checkStreakForReposList(
				user: userSettings.username,
				mainRepo: userSettings.mainRepository
			) {
				print($0.localizedDescription)
				showAlert = true
			}
			
			Task { @MainActor in
				withAnimation {
					repositoriesData = tempData
				}
			}
		}
	}
}
