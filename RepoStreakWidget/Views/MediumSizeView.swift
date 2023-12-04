//
//  MediumSizeView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 10/11/2023.
//

import SwiftUI

struct MediumSizeView: View {
	var entry: SimpleEntry
	
	@Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
	
	var body: some View {
		HStack(spacing: 20) {
			MainRepoWidget(entry: entry)
			
			RoundedRectangle(cornerRadius: 25)
				.frame(width: 3)
				.foregroundStyle(.secondary)
			
			if let reposList = entry.repoData.reposList {
				VStack(alignment: .leading) {
					Spacer()
					
					ForEach(reposList.prefix(5), id: \.name) { repo in
						HStack {
							if differentiateWithoutColor && !repo.extended {
								Image(systemName: "xmark")
									.font(.caption)
									.foregroundStyle(.gray)
							} else {
								Image(systemName: "flame")
									.font(.caption)
									.foregroundStyle(repo.extended ? .orange : .gray)
							}
							
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
