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
		
		@State private var hapticFeedback = UINotificationFeedbackGenerator()
		
		func performURLRequest() async {
			hapticFeedback.prepare()
			
			let fetchedData = await ReposFetcher.getPublicActiveRepositoriesNames(for: UserSettings.shared.username)
			
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
