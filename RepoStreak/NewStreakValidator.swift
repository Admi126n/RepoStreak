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
    let date: String
}

/// This new streak validator will not only check if streak is extended but also how long the streak is
struct NewStreakValidator {
    var link: String = ""
    
    func getCommits() async throws -> [CommitData] {
        
        guard let safeURL = URL(string: link) else {
            throw ValidatorErrors.cannotCreateURL
        }
        
        let (data, _) = try! await URLSession.shared.data(from: safeURL)
        
        let decodedData = try! JSONDecoder().decode([CommitData].self, from: data)
        
        return decodedData
    }
}
