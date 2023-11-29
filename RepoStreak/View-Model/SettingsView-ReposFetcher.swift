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
			
			let tempData = await ReposFetcher.getPublicActiveRepositoriesNames(for: UserSettings().username)
			
			switch tempData {
			case .success(let success):
				Task { @MainActor in
					withAnimation {
						repositories = success
					}
				}
			case .failure(let failure):
				print(failure.localizedDescription)
				showAlert = true
				hapticFeedback.notificationOccurred(.error)
			}
		}
	}
}
