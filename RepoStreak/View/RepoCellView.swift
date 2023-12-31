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
	
	@Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
	
	var body: some View {
		HStack {
			Text(name)
				.font(.headline)
				.foregroundStyle(pushedToday ? .green : .red)
			
			Spacer()
			
			Text("\(streakDuration)")
				.font(.headline)
				.foregroundStyle(pushedToday ? .orange : .gray)
			
			if differentiateWithoutColor && !pushedToday {
				Image(systemName: "xmark")
					.font(.headline)
					.foregroundStyle(.gray)
			} else {
				Image(systemName: "flame")
					.font(.headline)
					.foregroundStyle(pushedToday ? .orange : .gray)
			}
		}
		.padding(.horizontal)
		.padding(.vertical, 5)
		.background(Color(white: 0.15))
		.clipShape(.rect(cornerRadius: 25))
		.accessibilityElement(children: .combine)
		.accessibilityLabel("\(name), streak of \(streakDuration) days")
		.accessibilityHint(pushedToday ? I18n.streakExtended : I18n.streakNotExtended)
	}
}

#Preview {
	RepoCellView(name: "Example", streakDuration: 5, pushedToday: .random())
}
