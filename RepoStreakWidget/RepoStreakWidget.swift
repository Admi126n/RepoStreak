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
		SimpleEntry(date: Date(), emoji: "😀")
	}
	
	func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry = SimpleEntry(date: Date(), emoji: "😀")
		completion(entry)
	}
	
	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		var entries: [SimpleEntry] = []
		
		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let currentDate = Date()
		for hourOffset in 0 ..< 5 {
			let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
			let entry = SimpleEntry(date: entryDate, emoji: "😀")
			entries.append(entry)
		}
		
		let timeline = Timeline(entries: entries, policy: .atEnd)
		completion(timeline)
	}
}

// MARK: - SimpleEntry

struct SimpleEntry: TimelineEntry {
	let date: Date
	let emoji: String
}

// MARK: - RepoStreakWidgetEntryVie

struct RepoStreakWidgetEntryView : View {
	var entry: Provider.Entry
	let pushedToday = true
	let streakDuration = 5
	let repoPushed = "Coding done for today!"
	let repoNotPushed = "Go code!"
	
	var body: some View {
		VStack {
			HStack(spacing: 10) {
				Image(systemName: "flame")
					.font(.largeTitle)
					.foregroundStyle(pushedToday ? .orange : .gray)
				
				Text("\(streakDuration)")
					.font(.largeTitle)
					.foregroundStyle(pushedToday ? .orange : .gray)
			}
			
			Text(pushedToday ? repoPushed : repoNotPushed)
				.font(.headline)
				.foregroundStyle(pushedToday ? .green : .red)
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
	SimpleEntry(date: .now, emoji: "😀")
}
