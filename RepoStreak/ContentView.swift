//
//  ContentView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 24/09/2023.
//

import SwiftUI

fileprivate struct MainRepo: View {
	private let repoPushed = "Coding done for today!"
	private let repoNotPushed = "Go code!"
	
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
			
			Text(pushedToday ? repoPushed : repoNotPushed)
				.font(.title)
				.foregroundStyle(pushedToday ? .green : .red)
		}
	}
}

fileprivate struct RepoCell: View {
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
	}
}

struct ContentView: View {
    private let alertTitle = "Something went wrong"
    
    @State private var repoPushedToday = false
    @State private var showAlert = false
    @State private var showSheet = false
    @State private var alertMessage = ""
    @State private var streakDuration = 0
	@State private var reposList: [(name: String, duration: Int, pushedToday: Bool)] = []
    
    @StateObject var repoData = RepositoryData()
    
    var body: some View {
        NavigationStack {
			VStack {
				Spacer()
				
				MainRepo(
					streakDuration: streakDuration,
					pushedToday: repoPushedToday
				)
				
				Spacer()
				
				ForEach(reposList, id: \.name) { repo in
					RepoCell(name: repo.name, streakDuration: repo.duration, pushedToday: repo.pushedToday)
				}
            }
            .symbolEffect(.bounce, value: repoPushedToday)
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSheet = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await performURLRequest()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .task {
            await performURLRequest()
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .sheet(isPresented: $showSheet) {
            SettingsView(repoData: repoData)
        }
    }
    
    private func performURLRequest() async {
        do {
            (streakDuration, repoPushedToday) = try await StreakCounter.checkStreak(
                user: repoData.username,
                repo: repoData.repositoryName)
			
			reposList = try await StreakCounter.checkStreakForReposList(user: repoData.username, mainRepo: repoData.repositoryName)
        } catch ValidatorErrors.cannotCreateURLSession {
            alertMessage = "Cannot create URL session, check internet connection and your repo link"
            showAlert = true
        } catch ValidatorErrors.cannotDecodeData {
            alertMessage = "Cannot read fetched data"
            showAlert = true
        } catch ValidatorErrors.cannotCreateURL {
            alertMessage = "Cannot create URL, check your repo link"
            showAlert = true
        } catch {
            alertMessage = "Unknown error"
            showAlert = true
        }
    }
}

#Preview {
	ContentView()
}
