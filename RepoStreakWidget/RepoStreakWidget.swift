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
	@Environment(\.widgetFamily) var widgetFamily
	
	var entry: Provider.Entry
	
	var body: some View {
		switch widgetFamily {
		case .systemSmall:
			SmallSizeView(entry: entry)
		case .systemMedium:
			MediumSizeView(entry: entry)
		case .systemLarge:
			LargeSizeView(entry: entry)
		case .accessoryCircular:
			LockScreenWidget(entry: entry)
		default:
			Text(I18n.notImplemented)
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
		.supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .accessoryCircular])
		.configurationDisplayName(I18n.configurationDisplayName)
		.description(I18n.widgetDescription)
	}
}

// MARK: - Preview

#Preview("Small", as: .systemSmall) {
	RepoStreakWidget()
} timeline: {
	SimpleEntry(date: .now, repoData: RepositoriesData())
}

#Preview("Medium", as: .systemMedium) {
	RepoStreakWidget()
} timeline: {
	SimpleEntry(date: .now, repoData: RepositoriesData())
}

#Preview("Large", as: .systemLarge) {
	RepoStreakWidget()
} timeline: {
	SimpleEntry(date: .now, repoData: RepositoriesData())
}

#Preview("Lock screen", as: .accessoryCircular) {
	RepoStreakWidget()
} timeline: {
	SimpleEntry(date: .now, repoData: RepositoriesData())
}
