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
			
			let tempData = await ReposFetcher.getRepositories(for: UserSettings().username) {
				print($0.localizedDescription)
				showAlert = true
				hapticFeedback.notificationOccurred(.error)
				return
			}
			
			Task { @MainActor in
				withAnimation {
					repositories = tempData
				}
			}
		}
	}
}
