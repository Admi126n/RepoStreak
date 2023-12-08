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
		@Published var gettingData = false
		
		@State private var hapticFeedback = UINotificationFeedbackGenerator()
		
		func performURLRequest() async {
			defer {
				withAnimation {
					gettingData = false
				}
			}
			
			withAnimation {
				gettingData = true
			}
			hapticFeedback.prepare()
			
			let fetchedData = await ReposFetcher.getPublicActiveRepositoriesNames(for: UserSettings().username)
			
			switch fetchedData {
			case .success(let success):
				Task { @MainActor in
					withAnimation {
						repositories = success
					}
				}
			case .failure(_):
				showAlert = true
				hapticFeedback.notificationOccurred(.error)
			}
		}
	}
}
