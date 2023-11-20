//
//  LockScreenWidget.swift
//  RepoStreakWidgetExtension
//
//  Created by Adam Tokarski on 20/11/2023.
//

import SwiftUI

fileprivate struct ExtendedView: View {
	let duration: Int
	
	var body: some View {
		VStack(spacing: 5) {
			Image(systemName: "flame")
				.resizable()
				.scaledToFit()
			
			Text("\(duration)")
				.font(.headline)
				.bold()
				.padding(.horizontal)
				.background(.black)
				.clipShape(.rect(cornerRadius: 10))
		}
	}
}

fileprivate struct NotExtendedView: View {
	var body: some View {
		ZStack {
			Image(systemName: "flame")
				.font(.system(size: 40))
			
			
			Image(systemName: "xmark")
				.font(.system(size: 50))
		}
	}
}

struct LockScreenWidget: View {
	var entry: SimpleEntry
	
	var body: some View {
		if entry.repoData.mainExtended {
			ExtendedView(duration: entry.repoData.mainDuration)
		} else {
			NotExtendedView()
		}
	}
}
