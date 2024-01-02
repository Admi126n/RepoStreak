//
//  MediumSizeView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 10/11/2023.
//

import SwiftUI
import WidgetKit

struct MediumSizeView: View {
	var entry: SimpleEntry
	
	@Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
	
	var body: some View {
		GeometryReader { geo in
			HStack(spacing: 15) {
				MainRepoWidget(entry: entry)
					.frame(maxWidth: geo.size.width / 3, maxHeight: .infinity)
				
				RoundedRectangle(cornerRadius: 25)
					.frame(width: 3)
					.foregroundStyle(.secondary)
				
				if let reposList = entry.repoData.reposList {
					VStack(alignment: .leading) {
						Spacer()
						
						ForEach(reposList.prefix(4), id: \.name) { repo in
							HStack {
								RepoCellSymbol(repo, differentiateWithoutColor)
								
								Text(repo.name)
									.font(.caption)
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

struct MediumSizeViewPreviews: PreviewProvider {
	static var previews: some View {
		VStack {
			MediumSizeView(entry: SimpleEntry(date: .now, repoData: RepositoriesData.example))
		}
		.previewContext(WidgetPreviewContext(family: .systemMedium))
		.containerBackground(.background, for: .widget)
	}
}
