//
//  RepoStreakWidget.swift
//  RepoStreakWidget
//
//  Created by Adam Tokarski on 02/11/2023.
//

import WidgetKit
import SwiftUI

// MARK: - Provider

struct Provider: TimelineProvider {
	func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), repoData: RepositoriesData())
	}
	
	func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let userSettings = UserSettings()
				
		Task {
			let fetchedData = await StreakCounter.checkStreakForReposList(
				user: userSettings.username,
				mainRepo: userSettings.mainRepository
			) {
				print($0.localizedDescription)
			}
			
			let entry = SimpleEntry(date: .now, repoData: fetchedData)
			completion(entry)
		}
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		let userSettings = UserSettings()
		
		Task {
			let fetchedData = await StreakCounter.checkStreakForReposList(
				user: userSettings.username,
				mainRepo: userSettings.mainRepository
			) {
				print($0.localizedDescription)
			}
			let entry = SimpleEntry(date: .now, repoData: fetchedData)
			let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 10)))
			
			completion(timeline)
		}
	}
}

// MARK: - SimpleEntry

struct SimpleEntry: TimelineEntry {
	let date: Date
	let repoData: RepositoriesData
}

// MARK: - RepoStreakWidgetEntryVie

struct RepoStreakWidgetEntryView : View {
	var entry: Provider.Entry
	let repoPushed = "Coding done for today!"
	let repoNotPushed = "Go code!"
	
	var body: some View {
		VStack {
			HStack(spacing: 10) {
				Image(systemName: "flame")
					.font(.largeTitle)
					.foregroundStyle(entry.repoData.mainExtended ? .orange : .gray)
				
				Text("\(entry.repoData.mainDuration)")
					.font(.largeTitle)
					.foregroundStyle(entry.repoData.mainExtended ? .orange : .gray)
			}
			
			Text(entry.repoData.mainExtended ? repoPushed : repoNotPushed)
				.font(.headline)
				.foregroundStyle(entry.repoData.mainExtended ? .green : .red)
				.multilineTextAlignment(.center)
		}
	}
}

// MARK: - RepoStreakWidget

struct RepoStreakWidget: Widget {
	let kind: String = "RepoStreakWidget"
	
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			if #available(iOS 17.0, *) {
				RepoStreakWidgetEntryView(entry: entry)
					.containerBackground(Color(white: 0.15), for: .widget)
			} else {
				RepoStreakWidgetEntryView(entry: entry)
					.background(Color(white: 0.15))
			}
		}
		.configurationDisplayName("My Widget")
		.description("This is an example widget.")
	}
}

// MARK: - Preview

#Preview(as: .systemSmall) {
	RepoStreakWidget()
} timeline: {
	SimpleEntry(date: .now, repoData: RepositoriesData())
}
