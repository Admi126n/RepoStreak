//
//  MainRepoView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 02/11/2023.
//

import SwiftUI

struct MainRepoView: View {
	let name: String
	let streakDuration: Int
	let pushedToday: Bool
	
	@Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
	
	var body: some View {
		VStack {
			HStack(spacing: 10) {
				ZStack {
					Image(systemName: "flame")
						.font(.system(size: 70))
						.foregroundStyle(pushedToday ? .orange : .gray)
					
					if differentiateWithoutColor && !pushedToday {
						Image(systemName: "xmark")
							.font(.system(size: 80))
							.foregroundStyle(.gray)
					}
				}
				
				Text("\(streakDuration)")
					.font(.system(size: 80))
					.foregroundStyle(pushedToday ? .orange : .gray)
			}
			
			Text(pushedToday ? "Coding done for today!" : "Go code!")
				.font(.title)
				.foregroundStyle(pushedToday ? .green : .red)
		}
		.accessibilityElement(children: .combine)
		.accessibilityLabel("\(name), streak of \(streakDuration) days")
		.accessibilityHint(pushedToday ? I18n.streakExtended : I18n.streakNotExtended)
	}
}

#Preview {
	MainRepoView(name: "Example", streakDuration: 5, pushedToday: .random())
}
