//
//  MainRepoView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 02/11/2023.
//

import SwiftUI

struct MainRepoView: View {
	let streakDuration: Int
	let pushedToday: Bool
	
	var body: some View {
		Group {
			HStack(spacing: 25) {
				Image(systemName: "flame")
					.font(.system(size: 70))
					.foregroundStyle(pushedToday ? .orange : .gray)
				
				Text("\(streakDuration)")
					.font(.system(size: 80))
					.foregroundStyle(pushedToday ? .orange : .gray)
			}
			
			Text(pushedToday ? I18n.streakExtended : I18n.streakNotExtended)
				.font(.title)
				.foregroundStyle(pushedToday ? .green : .red)
		}
	}
}

#Preview {
	MainRepoView(streakDuration: 5, pushedToday: .random())
}
