//
//  LargeSizeView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 10/11/2023.
//

import SwiftUI
import WidgetKit

struct LargeSizeView: View {
	var entry: SimpleEntry
	
	@Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
	
	var body: some View {
		GeometryReader { geo in
			VStack(spacing: 5) {
				MainRepoWidget(entry: entry)
					.frame(maxWidth: .infinity, maxHeight: geo.size.height / 3)
				
				RoundedRectangle(cornerRadius: 25)
					.frame(height: 3)
					.foregroundStyle(.secondary)
				
				if let reposList = entry.repoData.reposList {
					VStack(alignment: .leading) {
						Spacer()
						
						ForEach(reposList.prefix(5), id: \.name) { repo in
							HStack {
								HStack(spacing: 3) {
									RepoCellSymbol(repo, differentiateWithoutColor)
										.font(.body)
									
									Text("\(repo.duration)")
										.font(.body)
										.foregroundStyle(repo.extended ? .orange : .gray)
								}
								
								Text(repo.name)
									.font(.body)
									.foregroundStyle(repo.extended ? .green : .red)
							}
							
							Spacer()
						}
					}
				}
			}
		}
	}
}

struct LargeSizeViewPreviews: PreviewProvider {
	static var previews: some View {
		VStack {
			LargeSizeView(entry: SimpleEntry(date: .now, repoData: RepositoriesData.example))
		}
		.previewContext(WidgetPreviewContext(family: .systemLarge))
		.containerBackground(.background, for: .widget)
	}
}
