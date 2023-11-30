//
//  BranchesFetcher.swift
//  RepoStreak
//
//  Created by Adam Tokarski on 29/11/2023.
//

import Foundation

/// Contains methods for fetching list of branches for specified user and repository.
struct BranchesFetcher {
	
	/// Empty private init to prevent creating instances of this struct
	///
	/// BranchesFetcher contains only static methods so instances are unnecessary.
	private init() { }
	
	
	/// Creates URL for GitHub API request
	/// - Parameters:
	///   - user: String with GitHub username
	///   - repo: String with GitHub repository name
	/// - Returns: URL for GitHub API request
	///
	/// API documentation:
	/// https://docs.github.com/en/rest/branches/branches?apiVersion=2022-11-28#list-branches
	private static func buildLink(for user: String, _ repo: String) throws -> URL {
		guard let url = URL(string: "https://api.github.com/repos/\(user)/\(repo)/branches") else {
			throw(URLError(.badURL))
		}
		
		return url
	}
	
	
	/// Returnes list of branches names from provided branches data
	/// - Parameter branches: Branch data
	/// - Returns: List of branches names
	private static func getNames(for branches: [BranchData]) -> [String] {
		branches.map { $0.name }
	}
	
	
	/// Returns list with data of all available branches for privided `user` and `repo`. If API request fails returns an error
	/// - Parameters:
	///   - user: String with GitHub username
	///   - repo: String with GitHub repository name
	/// - Returns: List of fetched branches
	private static func getBranches(for user: String, _ repo: String) async -> Result<[BranchData], Error> {
		do {
			let url = try buildLink(for: user, repo)
			let fetchedData: [BranchData] = try await url.fetchData()
			
			return .success(fetchedData)
		} catch {
			return .failure(error)
		}
	}

	
	/// Returns names of all available branches for privided `user` and `repo`. If API request fails returns an error
	/// - Parameters:
	///   - user: String with GitHub username
	///   - repo: String with GitHub repository name
	/// - Returns: List of branches names
	static func getBranchesNames(for user: String, _ repo: String) async -> Result<[String], Error> {
		let fetchedData = await getBranches(for: user, repo)
		
		switch fetchedData {
		case .success(let success):
			return .success(getNames(for: success))
		case .failure(let failure):
			return .failure(failure)
		}
	}
}

// MARK: - Structs needed for decoding fetched data

/// Struct needed for decoding data fetched from GitHub API
fileprivate struct BranchData: Codable {
	
	let name: String
}
