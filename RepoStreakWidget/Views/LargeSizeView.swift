//
//  LargeSizeView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 10/11/2023.
//

import SwiftUI

struct LargeSizeView: View {
	var entry: SimpleEntry
	
	var body: some View {
		VStack(spacing: 20) {
			MainRepoWidget(entry: entry)
			
			RoundedRectangle(cornerRadius: 25)
				.frame(height: 3)
				.foregroundStyle(.secondary)
			
			if let reposList = entry.repoData.reposList {
				VStack(alignment: .leading) {
					Spacer()
					
					ForEach(reposList.prefix(5), id: \.name) { repo in
						HStack {
							HStack(spacing: 3) {
								Image(systemName: "flame")
									.font(.body)
									.foregroundStyle(repo.extended ? .orange : .gray)
								
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
