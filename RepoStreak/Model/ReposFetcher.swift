//
//  ReposFetcher.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 03/10/2023.
//

import Foundation

/// Contains methods for fetching list of public repositories for specified user.
struct ReposFetcher {
	
	/// Empty private init to prevent creating instances of this struct
	///
	/// ReposFetcher contains only static methods so instances are unnecessary.
	private init() { }
	
	
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
	
	
	/// Returns all not archived repositories names from given repositories list
	/// - Parameter repos: List of both archived and not archived repositories
	/// - Returns: List of not archoved repositories names
	private static func getActiveRepositoriesNames(from repos: [Repository]) -> [String] {
		let filteredRepos = repos.filter{ $0.isActive() }
		
		return filteredRepos.map { $0.name }
	}
	
	
	/// Returns list with all public repositories for provided `user`. If API request fails returns an error
	/// - Parameter user: String with GitHub username
	/// - Returns: List of fetched repositories
	private static func getPublicRepositories(for user: String) async -> Result<[Repository], Error> {
		do {
			let url = try buildLink(for: user)
			let fetchedData: [Repository] = try await url.fetchData()
			
			return .success(fetchedData)
		} catch {
			return .failure(error)
		}
	}
	
	
	/// Returns names of all available public not archived repositories for provided `user`. If request to GitHub API fails returns an error
	/// - Parameter user: String with GitHub username
	/// - Returns: List of repositories names
	static func getPublicActiveRepositoriesNames(for user: String) async -> Result<[String], Error> {
		let fetchedData = await getPublicRepositories(for: user)
		
		switch fetchedData {
		case .success(let success):
			return .success(getActiveRepositoriesNames(from: success))
		case .failure(let failure):
			return .failure(failure)
		}
	}
	
}

// MARK: - Structs needed for decoding fetched data

/// Struct needed for decoding data fetched from GitHub API
fileprivate struct Repository: Codable {
	
	let name: String
	let archived: Bool
	
	
	/// - Returns: True is repository is not archived
	func isActive() -> Bool {
		!archived
	}
}
