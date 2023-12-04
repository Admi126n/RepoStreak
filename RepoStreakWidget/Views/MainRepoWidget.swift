//
//  MainRepoWidget.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 11/11/2023.
//

import SwiftUI

struct MainRepoWidget: View {
	var entry: SimpleEntry
	
	@Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
	
	var body: some View {
		VStack {
			HStack(spacing: 10) {
				ZStack {
					Image(systemName: "flame")
						.font(.largeTitle)
						.foregroundStyle(entry.repoData.mainExtended ? .orange : .gray)
					
					if differentiateWithoutColor && !entry.repoData.mainExtended {
						Image(systemName: "xmark")
							.font(.system(size: 40))
							.foregroundStyle(.gray)
					}
				}
				
				Text("\(entry.repoData.mainDuration)")
					.font(.largeTitle)
					.foregroundStyle(entry.repoData.mainExtended ? .orange : .gray)
			}
			
			Text(entry.repoData.mainExtended ? "Coding done for today!" : "Go code!")
				.font(.headline)
				.foregroundStyle(entry.repoData.mainExtended ? .green : .red)
				.multilineTextAlignment(.center)
		}
	}
}
