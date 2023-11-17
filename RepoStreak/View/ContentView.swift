//
//  ContentView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 24/09/2023.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
	@Environment(\.scenePhase) var scenePhase
	@StateObject var contentViewModel = ContentViewModel()
	
	var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				
				MainRepoView(
					streakDuration: contentViewModel.repositoriesData.mainDuration,
					pushedToday: contentViewModel.repositoriesData.mainExtended
				)
				
				Spacer()
				
				if let reposList = contentViewModel.repositoriesData.reposList {
					ForEach(reposList, id: \.name) { repo in
						RepoCellView(
							name: repo.name,
							streakDuration: repo.duration,
							pushedToday: repo.extended
						)
						
					}
				}
			}
			.symbolEffect(.bounce, value: contentViewModel.repositoriesData.mainDuration)
			.padding()
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button {
						contentViewModel.showSheet = true
					} label: {
						Image(systemName: "gearshape")
					}
				}
				
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						Task {
							await contentViewModel.performURLRequest()
						}
					} label: {
						Image(systemName: "arrow.clockwise")
					}
				}
			}
		}
		.preferredColorScheme(.dark)
		.task { await contentViewModel.performURLRequest() }
		.alert(I18n.alertTitle, isPresented: $contentViewModel.showAlert) { }
		.sheet(isPresented: $contentViewModel.showSheet) {
			SettingsView(userSettings: contentViewModel.userSettings) {
				Task {
					await contentViewModel.performURLRequest()
				}
			}
		}
		.onChange(of: scenePhase) {
			if scenePhase == .background {
				WidgetCenter.shared.reloadAllTimelines()
			}
		}
	}
}

#Preview {
	ContentView()
}
