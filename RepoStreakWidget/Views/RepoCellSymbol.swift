//
//  RepoCellWidget.swift
//  RepoStreakWidgetExtension
//
//  Created by Adam Tokarski on 08/12/2023.
//

import SwiftUI
import WidgetKit

struct RepoCellSymbol: View {
	let differentiateWithoutColor: Bool
	let repo: RepoData
	
	var body: some View {
		if differentiateWithoutColor && !repo.extended {
			Image(systemName: "xmark")
				.foregroundStyle(.gray)
		} else {
			Image(systemName: "flame")
				.foregroundStyle(repo.extended ? .orange : .gray)
		}
	}
	
	init(_ repo: RepoData, _ differentiateWithoutColor: Bool) {
		self.differentiateWithoutColor = differentiateWithoutColor
		self.repo = repo
	}
}
