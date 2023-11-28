//
//  ReposFetcher.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 03/10/2023.
//

import Foundation

/// Contains methods for fetching list of public repositories for specified user.
struct ReposFetcher {
	
	/// Creates URL for GitHub API request
	/// - Parameter user: String with GitHub username
	/// - Returns: URL for GitHub API request
	///
	/// Method uses GitHub API for fething repositories for the specified user.
	///
	/// API documentation:
	/// https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#list-repositories-for-a-user
	private static func buildLink(for user: String) throws -> URL {
		guard let url = URL(string: "https://api.github.com/users/\(user)/repos") else {
			throw(URLError(.badURL))
		}
		
		return url
	}
	
	
	/// Returns list with available public repositories for provided user. If API request fails returns an error
	/// - Parameter user: String with GitHub username
	/// - Returns: List of
	static func getRepositoriesNames(for user: String) async -> Result<[String], Error> {
		do {
			let url = try buildLink(for: user)
			let fetchedData: [Repository] = try await url.fetchData()
			
			return .success(getNames(from: fetchedData))
		} catch {
			return .failure(error)
		}
	}
	
	@available(*, deprecated, message: "use URL.fetchData() instead")
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
	
	@available(*, deprecated, message: "method will be replaced by CommitsFetcher.getDates")
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
	
	/// Deprecated, use ``getRepositoriesNames(for:)`` instead
	@available(*, deprecated, message: "method will be replaced by getRepositoriesNames")
	static func getRepositories(for user: String, _ compleationHandler: (Error) -> ()) async -> [String] {
		let link = "https://api.github.com/users/\(user)/repos"
		var fetchedData: [Repository] = []
		
		do {
			fetchedData = try await fetchData(from: link)
		} catch {
			compleationHandler(error)
		}
		
		return getNames(from: fetchedData)
	}
	
	@available(*, deprecated, message: "method will be replaced by CommitsFetcher.getCommitsDates")
	static func getCommitsDates(_ user: String, _ repo: String, _ compleationHandler: (Error) -> ()) async -> [Date] {
		let link = "https://api.github.com/repos/\(user)/\(repo)/commits?per_page=100"
		
		let decoder = JSONDecoder()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		decoder.dateDecodingStrategy = .formatted(dateFormatter)
		
		var fetchedData: [CommitData] = []
		
		do {
			fetchedData = try await ReposFetcher.fetchData(from: link, using: decoder)
		} catch {
			compleationHandler(error)
		}
		
		return getDates(from: fetchedData)
	}
}

// MARK: - Structs needed for decoding fetched data

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
