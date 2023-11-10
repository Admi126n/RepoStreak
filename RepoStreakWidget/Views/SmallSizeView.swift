//
//  SmallSizeView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 10/11/2023.
//

import SwiftUI

struct SmallSizeView: View {
	var entry: SimpleEntry
	
	var body: some View {
		MainRepoWidget(entry: entry)
	}
}
