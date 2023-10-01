//
//  NewStreakValidator.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 30/09/2023.
//

import Foundation

struct CommitData: Codable {
    let commit: Commit
}

struct Commit: Codable {
    let author: Author
}

struct Author: Codable {
    let date: Date
}

struct NewStreakValidator {
     static func getCommitsDates(_ user: String, _ repo: String) async throws -> [Date] {
        let link = "https://api.github.com/repos/\(user)/\(repo)/commits?per_page=100"
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        var dates: [Date] = []
        
        guard let safeURL = URL(string: link) else {
            throw ValidatorErrors.cannotCreateURL
        }
        
        guard let (data, _) = try? await URLSession.shared.data(from: safeURL) else {
            throw ValidatorErrors.cannotCreateURLSession
        }
        
        guard let decodedData = try? decoder.decode([CommitData].self, from: data) else {
            throw ValidatorErrors.cannotDecodeData
        }
        
        dates = getDatesFromCommits(decodedData)
        
        return dates
    }
    
    static func getDatesFromCommits(_ commits: [CommitData]) -> [Date] {
        var dates: [Date] = []
        
        for commit in commits {
            dates.append(commit.commit.author.date)
        }
        
        return dates
    }
    
    static func countStreak(for commits: [Date]) -> Int {
        var commitsList = commits
        
        let today = Date.now
        var subtractingDays = 0
        var streakDuration = 0
        
        if Calendar.current.isDate(commitsList[0], equalTo: today, toGranularity: .day) {
            streakDuration += 1
            subtractingDays -= 1
            commitsList.remove(at: 0)
        } else if Calendar.current.isDate(
            commitsList[0],
            equalTo: Calendar.current.date(byAdding: .day, value: -1, to: today)!,
            toGranularity: .day) {
            
            streakDuration += 1
            subtractingDays -= 2
            commitsList.remove(at: 0)
        }
        
        guard streakDuration != 0 else {
            return 0
        }
        
        for commit in commitsList {
            if Calendar.current.isDate(
                commit,
                equalTo: Calendar.current.date(byAdding: .day, value: subtractingDays, to: today)!,
                toGranularity: .day) {
                
                subtractingDays -= 1
                streakDuration += 1

            } else {
                return streakDuration
            }
        }
        
        return streakDuration
    }
    
    static func checkStreak(user: String, repo: String) async throws -> Int {
        do {
            let commitsDates = try await getCommitsDates(user, repo)
            
            return countStreak(for: commitsDates)
        } catch {
            
            return 0
        }
    }
    
}
