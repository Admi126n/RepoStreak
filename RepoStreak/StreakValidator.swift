//
//  StreakValidator.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 24/09/2023.
//

import Foundation

struct StreakValidator {
    private struct Repository: Codable {
        let pushed_at: Date
    }
    
    private static let repoLink = "https://api.github.com/repos/"
    
    static func validate(user: String, repo: String) async throws -> Bool {
        let link = repoLink + "\(user)/\(repo)"
        
        guard let safeURL = URL(string: link) else {
            throw ValidatorErrors.cannotGetURL
        }
        
        guard let (data, _) = try? await URLSession.shared.data(from: safeURL) else {
            throw ValidatorErrors.cannotCreateURLSession
        }
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let decodedData = try? decoder.decode(Repository.self, from: data) else {
            throw ValidatorErrors.cannotDecodeData
        }
        
        return checkRepoDate(decodedData.pushed_at)
    }
    
    private static func checkRepoDate(_ date: Date) -> Bool {
        Calendar.current.isDate(date, equalTo: Date.now, toGranularity: .day)
    }
}
