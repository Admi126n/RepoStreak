//
//  ContentView.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 24/09/2023.
//

import SwiftUI

struct ContentView: View {
    private let repoLink = "https://api.github.com/repos/admi126n/100daysofswiftui"
    private let repoPushed = "Coding done for today"
    private let repoNotPushed = "Go code!"
    
    @State private var repoPushedToday = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "flame")
                    .font(.system(size: 70))
                    .foregroundStyle(repoPushedToday ? .orange : .gray)
                Text(repoPushedToday ? repoPushed : repoNotPushed)
                    .font(.title)
                    .foregroundStyle(repoPushedToday ? .green : .red)
            }
            .symbolEffect(.bounce, value: repoPushedToday)
            .padding()
            .navigationTitle("Repo Streak")
            .toolbar {
                Button {
                    performURLRequest()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear(perform: performURLRequest)
    }
    
    private func performURLRequest() {
        if let safeUrl = URL(string: repoLink) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: safeUrl) { data, response, error in
                if let safeData = data {
                    parseJson(safeData)
                }
            }
            task.resume()
        }
    }
    
    private func parseJson(_ data: Data) {
        if let decodedData = try? JSONDecoder().decode(Repository.self, from: data) {
            
            let repoDate = getDateFrom(string: decodedData.pushed_at)
            repoPushedToday = checkRepoDate(repoDate)
        }
    }
    
    private func getDateFrom(string date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.date(from: date)!
    }
    
    private func checkRepoDate(_ date: Date) -> Bool {
        Calendar.current.isDate(date, equalTo: Date.now, toGranularity: .day)
    }
}

#Preview {
    ContentView()
}

// MARK: - Custom structs

fileprivate struct Repository: Codable {
    let pushed_at: String
}
