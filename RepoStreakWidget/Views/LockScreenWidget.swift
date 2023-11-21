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
		ZStack {
			Image(systemName: "flame")
				.resizable()
				.scaledToFit()
			
			Image(systemName: "flame.fill")
				.resizable()
				.scaledToFit()
			
			VStack {
				Spacer()
				Spacer()
				
				Text("\(duration)")
					.font(.headline)
					.blendMode(.destinationOut)
				
				Spacer()
			}
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
