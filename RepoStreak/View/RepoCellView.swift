//
//  RepoCellView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 02/11/2023.
//

import SwiftUI

struct RepoCellView: View {
	let name: String
	let streakDuration: Int
	let pushedToday: Bool
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 25)
				.frame(height: 30)
				.foregroundStyle(Color(white: 0.15))
			
			HStack {
				Text(name)
					.font(.headline)
					.foregroundStyle(pushedToday ? .green : .red)
				
				Spacer()
				
				Text("\(streakDuration)")
					.font(.headline)
					.foregroundStyle(pushedToday ? .orange : .gray)
				
				Image(systemName: "flame")
					.font(.headline)
					.foregroundStyle(pushedToday ? .orange : .gray)
			}
			.padding(.horizontal)
		}
		.accessibilityElement(children: .combine)
		.accessibilityLabel("\(name), streak of \(streakDuration) days")
		.accessibilityHint(pushedToday ? I18n.streakExtended : I18n.streakNotExtended)
	}
}

#Preview {
	RepoCellView(name: "Example", streakDuration: 5, pushedToday: .random())
}
