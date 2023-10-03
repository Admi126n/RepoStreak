//
//  ReposFetcher.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 03/10/2023.
//

import Foundation

struct ReposFetcher {
    private struct Repository: Codable {
        let name: String
        let archived: Bool
    }
    
    static func getRepositories(for user: String) async throws -> [String] {
        let link = "https://api.github.com/users/\(user)/repos"
        var result: [String] = []
        
        guard let safeURL = URL(string: link) else {
            throw ValidatorErrors.cannotCreateURL
        }
        
        guard let (data, _) = try? await URLSession.shared.data(from: safeURL) else {
            throw ValidatorErrors.cannotCreateURLSession
        }
        
        guard let decodedData = try? JSONDecoder().decode([Repository].self, from: data) else {
            throw ValidatorErrors.cannotDecodeData
        }
        
        for repo in decodedData {
            if !repo.archived {
                result.append(repo.name)
            }
        }
        
        return result
    }
}
