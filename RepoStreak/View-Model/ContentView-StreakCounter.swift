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
		@Published var gettingData = false
		
		@State private var hapticFeedback = UINotificationFeedbackGenerator()
		
		var reposList: [RepoData] {
			repositoriesData.reposList ?? []
		}
		
		func performURLRequest() async {
			withAnimation {
				gettingData = true
			}
			hapticFeedback.prepare()
			
			let tempData = await StreakCounter.checkStreak(for: userSettings.username)
			
			Task { @MainActor in
				withAnimation {
					repositoriesData = tempData
				}
			}
			
			hapticFeedback.notificationOccurred(.success)
			withAnimation {
				gettingData = false
			}
		}
	}
}
