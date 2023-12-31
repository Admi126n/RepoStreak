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
			GeometryReader { geo in
				ZStack {
					VStack {
						Spacer()
						
						MainRepoView(
							name: contentViewModel.repositoriesData.mainRepoName,
							streakDuration: contentViewModel.repositoriesData.mainDuration,
							pushedToday: contentViewModel.repositoriesData.mainExtended
						)
						.frame(maxWidth: .infinity, maxHeight: 50)
						
						Spacer()
						
						ScrollView {
							VStack {
								ForEach(contentViewModel.reposList, id: \.name) { repo in
									RepoCellView(
										name: repo.name,
										streakDuration: repo.duration,
										pushedToday: repo.extended
									)
								}
							}
							.rotationEffect(Angle(degrees: 180))
						}
						.rotationEffect(Angle(degrees: 180))
						.scrollIndicators(.never)
						.frame(height: geo.size.height / 3)
					}
					
					if contentViewModel.gettingData {
						ProgressView("Downloading data")
							.padding()
							.background(.secondary.opacity(0.7))
							.clipShape(.rect(cornerRadius: 15))
							.dynamicTypeSize(...DynamicTypeSize.accessibility2)
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
					.disabled(contentViewModel.gettingData)
					.accessibilityLabel("Settings")
				}
				
				ToolbarItem(placement: .topBarTrailing) {
					Button {
						Task {
							await contentViewModel.performURLRequest()
						}
					} label: {
						Image(systemName: "arrow.clockwise")
					}
					.disabled(contentViewModel.gettingData)
					.accessibilityLabel("Refresh")
				}
			}
		}
		.tint(.orange)
		.preferredColorScheme(.dark)
		.task { await contentViewModel.performURLRequest() }
		.alert("Something went wrong.", isPresented: $contentViewModel.showAlert) { }
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
