//
//  StreakValidator.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 24/09/2023.
//

import Foundation

struct StreakValidator {
    private struct Repository: Codable {
        let pushed_at: String
    }
    
    static func validate(link: String) async throws -> Bool {
        guard let safeURL = URL(string: link) else {
            throw ValidatorErrors.cannotGetURL
        }
        
        guard let (data, _) = try? await URLSession.shared.data(from: safeURL) else {
            throw ValidatorErrors.cannotCreateURLSession
        }
        
        guard let decodedData = try? JSONDecoder().decode(Repository.self, from: data) else {
            throw ValidatorErrors.cannotDecodeData
        }
        
        let repoDate = getDateFrom(string: decodedData.pushed_at)
        return checkRepoDate(repoDate)
    }
    
    private static func getDateFrom(string date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.date(from: date)!
    }
    
    private static func checkRepoDate(_ date: Date) -> Bool {
        Calendar.current.isDate(date, equalTo: Date.now, toGranularity: .day)
    }
}
