//
//  SmallSizeView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 10/11/2023.
//

import SwiftUI
import WidgetKit

struct SmallSizeView: View {
	var entry: SimpleEntry
	
	var body: some View {
		MainRepoWidget(entry: entry)
	}
}

struct SmallSizeViewPreviews: PreviewProvider {
	static var previews: some View {
		VStack {
			SmallSizeView(entry: SimpleEntry(date: .now, repoData: RepositoriesData()))
		}
		.previewContext(WidgetPreviewContext(family: .systemSmall))
		.containerBackground(.background, for: .widget)
	}
}
