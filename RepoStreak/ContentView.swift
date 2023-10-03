//
//  ContentView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 24/09/2023.
//

import SwiftUI

struct ContentView: View {
    private let repoPushed = "Coding done for today!"
    private let repoNotPushed = "Go code!"
    private let alertTitle = "Something went wrong"
    
    @State private var repoPushedToday = false
    @State private var showAlert = false
    @State private var showSheet = false
    @State private var alertMessage = ""
    @State private var streakDuration = 0
    
    @StateObject var repoData = RepositoryData()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 25) {
                    Image(systemName: "flame")
                        .font(.system(size: 70))
                        .foregroundStyle(repoPushedToday ? .orange : .gray)
                    
                    Text("\(streakDuration)")
                        .font(.system(size: 80))
                        .foregroundStyle(repoPushedToday ? .orange : .gray)
                }
                    
                Text(repoPushedToday ? repoPushed : repoNotPushed)
                    .font(.title)
                    .foregroundStyle(repoPushedToday ? .green : .red)
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
