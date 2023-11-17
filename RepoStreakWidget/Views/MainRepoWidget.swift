//
//  MainRepoWidget.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 11/11/2023.
//

import SwiftUI

struct MainRepoWidget: View {
	var entry: SimpleEntry
	
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
			
			Text(entry.repoData.mainExtended ? I18n.streakExtended : I18n.streakNotExtended)
				.font(.headline)
				.foregroundStyle(entry.repoData.mainExtended ? .green : .red)
				.multilineTextAlignment(.center)
		}
	}
}
