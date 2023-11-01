//
//  ReposFetcher.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 03/10/2023.
//

import Foundation

fileprivate struct CommitData: Codable {
	let commit: Commit
}

fileprivate struct Commit: Codable {
	let author: Author
}

fileprivate struct Author: Codable {
	let date: Date
}

fileprivate struct Repository: Codable {
	let name: String
	let archived: Bool
}

struct ReposFetcher {
	private static func fetchData<T: Codable>(from link: String, using decoder: JSONDecoder = JSONDecoder()) async throws -> T {
		guard let safeURL = URL(string: link) else {
			throw URLError(.badURL)
		}
		
		guard let (data, _) = try? await URLSession.shared.data(from: safeURL) else {
			throw URLError(.badServerResponse)
		}
		
		guard let decodedData = try? decoder.decode(T.self, from: data) else {
			throw ValidatorErrors.cannotDecodeData
		}
		
		return decodedData
	}
	
	private static func getDates(from commits: [CommitData]) -> [Date] {
		var dates: [Date] = []
		
		for commit in commits {
			dates.append(commit.commit.author.date)
		}
		
		return dates
	}
	
	private static func getNames(from repos: [Repository]) -> [String] {
		var result: [String] = []
		
		for repo in repos {
			if !repo.archived {
				result.append(repo.name)
			}
		}
		
		return result
	}
	
	static func getRepositories(for user: String, _ compleationHandler: () -> ()) async -> [String] {
		let link = "https://api.github.com/users/\(user)/repos"
		var fetchedData: [Repository] = []
		
		do {
			fetchedData = try await fetchData(from: link)
		} catch {
			compleationHandler()
		}
		
		return getNames(from: fetchedData)
	}
	
	static func getCommitsDates(_ user: String, _ repo: String, _ compleationHandler: () -> ()) async -> [Date] {
		let link = "https://api.github.com/repos/\(user)/\(repo)/commits?per_page=100"
		
		let decoder = JSONDecoder()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		
		var fetchedData: [CommitData] = []
		
		do {
			fetchedData = try await ReposFetcher.fetchData(from: link, using: decoder)
		} catch {
			compleationHandler()
		}
		
		return getDates(from: fetchedData)
	}
	
	
	
	
}
